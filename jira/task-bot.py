# -*- coding: utf-8 -*-


# 3rd party library
try:
    from jira import JIRA
    from urllib.parse import urljoin
    from urllib.parse import urlencode
    import urllib.request as urlrequest
except ImportError:
    from urlparse import urljoin
    from urllib import urlencode
    import urllib2 as urlrequest
import json


class Slack():

    def __init__(self, url=""):
        self.url = url
        self.opener = urlrequest.build_opener(urlrequest.HTTPHandler())

    def notify(self, **kwargs):
        """
        Send message to slack API
        """
        return self.send(kwargs)

    def send(self, payload):
        """
        Send payload to slack API
        """
        payload_json = json.dumps(payload)
        #print(payload_json)
        data = urlencode({"payload": payload_json})
        req = urlrequest.Request(self.url)
        response = self.opener.open(req, data.encode('utf-8')).read()
        return response.decode('utf-8')
    def api_call(self,rqst):
        token=""
        req = urlrequest.Request(rqst)
        data = {"token":token}
        response = self.opener.open(req, data).read()
        return response.decode('utf-8')

task = {}
dashboard = []
attachments = []

severity_map={"None":"#A4A4A4",
              "Minor":"#74DF00",
              "Major":"#FFFF00",
              "Critical":"#FE9A2E",
              "Disaster":"#FF0000"}
severity_count={"None":0,
                "Minor":0,
                "Major":0,
                "Critical":0,
                "Disaster":0}
engineers={"name":'login'}

search_query = ''

options = {
    'server': 'https://'}
jira = JIRA(options, basic_auth=('login', 'pass'))
results = jira.search_issues(search_query, maxResults=50, expand=True)
#testing
#slack = Slack(url="https://hooks.slack.com/services/")
#abc-core
slack = Slack(url="https://hooks.slack.com/services/")

for issue in results:
    #print(issue.raw)
    #for field_name in issue.raw['fields']:
    #   print("Field:", field_name, "Value:", issue.raw['fields'][field_name])
    #print(issue.raw['fields']['resolution'])
    task['id'] = str(issue)
    task['url'] = issue.raw['fields']['votes']['self'].replace("/votes", "")
    task['url'] = task['url'].replace("rest/api/2/issue", "browse")
    task['name'] = issue.raw['fields']['summary']
    task['creator'] = issue.raw['fields']['creator']['name']
    task['assignee'] = issue.raw['fields']['assignee']['name']
    try:
        task['severity'] = issue.raw['fields']['customfield_10073']['value']
        severity_count[str(task['severity'])]+=1
    except KeyError:
        task['severity'] = "None"
        severity_count["None"]+=1
    dashboard.append(task)
    task = {}

#for t in dashboard:
#    print('{0:<25};; {1:<15};; {2:<10}'.format(severity_map[t['severity']],t['name'],t['url']))

for person in engineers.keys():
    attachments = []
    attachment = {}
    print(person)
    attachment['pretext'] = "<@" + engineers[person] + ">" + " please update following tickets:"
    attachments.append(attachment)
    for t in dashboard:
        attachment = {}
        if t['assignee'] == person:
            print(t)
            attachment["color"] = severity_map[t['severity']]
            attachment["title"] = t["id"] + " : " + t['name']
            attachment["title_link"] = t['url']
            #attachment["text"] = t['id']
            #attachment['task summary'] = t['name']
            attachments.append(attachment)
    slack.notify(attachments=attachments)
#print(attachments)



print(severity_count)
