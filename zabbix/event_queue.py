from collections import defaultdict
from datetime import datetime, timedelta
import json
import logging
import sys
import time

try:
    from urllib.request import urlopen
except ImportError:
    from urllib2 import urlopen


LOG_FORMAT = '[%(asctime)s.%(msecs)03.0fZ] %(levelname)s: %(process)d.%(pathname)s:%(lineno)d. %(message)s'
DATE_FORMAT = '%Y-%m-%dT%H:%M:%S'


def get_statistics(host):
    return json.loads(urlopen('http://{0}/system/statistics/equeue'.format(host)).read().decode('utf8'))


def date_formater(human):
    if human:
        return lambda x: datetime.fromtimestamp(x).isoformat()
    else:
        return str


def timedelta_formater(human):
    if human:
        return lambda x: str(timedelta(seconds=x))
    else:
        return str


def main(args):
    logging.basicConfig(level=logging.DEBUG, stream=sys.stderr, format=LOG_FORMAT, datefmt=DATE_FORMAT)

    date_format = date_formater(args.human)
    timedelta_format = timedelta_formater(args.human)

    result = defaultdict(lambda: defaultdict(int))
    now = int(time.time())
    try:
        for stat in get_statistics(args.host):
            result[stat['subscriber']][stat['status_human']] = stat['count']
            result[stat['subscriber']][stat['status_human'] + '_errors'] = stat['errors']
            result[stat['subscriber']][stat['status_human'] + '_updated'] = date_format(stat['last_update'])
            result[stat['subscriber']][stat['status_human'] + '_time'] = timedelta_format(now - stat['last_update'])

        if args.json_out:
            result = [dict(service=k, **v) for k, v in result.items()]
            json.dump({'data': [{"{#%s}" % k.upper(): v for k, v in record.items()} for record in result]}, sys.stdout)
        else:
            for service, records in result.items():
                service = service.replace('#', '-')
                for k, v in records.items():
                    print('-'.join((service, k)), '#', v)
        return 0
    except Exception as e:
        logging.exception('*** %r *** ', e)
        return 1

if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('--host', dest='host', help='target host', required=True)
    parser.add_argument('--json', dest='json_out', help='output in json format', action='store_true', default=False)
    parser.add_argument('--human', help='human readable output', action='store_true', default=False)
    sys.exit(main(parser.parse_args()))
