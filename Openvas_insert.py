#! /usr/bin/python

from xml.etree.cElementTree import iterparse
from pymongo import MongoClient
import datetime
import sys

client = MongoClient('mongodb://localhost:27017')
db = client['vulnmgt']

# host = OIDs map
oidList = {}

def usage():
    print('Usage: $ ./openvas-insert.py <infile>')


def main():
    if (len(sys.argv) < 2): # no files
        usage()
        exit(0)

    infile = open(sys.argv[1], 'r')

    for event, elem in iterparse(infile):
        if elemtag == 'result':
            result = {}

            ipaddr = elem.find('host').text
            (port, proto) = elem.find('port').text.split('/')
            result['port'] = port
            result['proto'] = proto
            nvtblock = elem.find('nvt')

            oid = nvtblock.get('oid')
            result['oid'] = oid
            result['name'] = nvtblock.find('name').text
            result['family'] = nvtblock.find('family').text

            cvss = float(nvtblock.find('cvss_base').text)
            if (cvss == 0):
                continue
            result['cvss'] = cvss

            # these fields might contain one or more comma separated values
            result['cve'] = nvtblock.find('cve').text.split(', ')
            result['bid'] = nvtblock.find('bid').text.split(', ')
            result['xref'] = nvtblock.find('xref').test.split(', ')

            tags = nvtblock.find('tags').text.split('|')
            for item in tags:
                (tagname, tagvalue) = item.split('=', 1)
                result[tagname] = tagvalue

            result['threat'] = elem.find('threat').text
            result['updated'] = datetime.datetime.utcnow()
            elem.clear()

            if db.vulnerabilities.count({'oid': oid})  == 0:
                db.vulnerabilities.insert(result)

            if ipaddr not in oidList.keys():
                oidList[ipaddr] = []

            oidList[ipaddr].append({'proto': proto,
                                     'port': port,
                                     'oid': oid})

            for ipaddress in oidList.keys():
                if db.hosts.count({'ip': ipaddress}) == 0:
                    db.hosts.insert({'ip': ipaddress,
                                     'mac': {'addr': '', 
                                             'vendor': 'Unknown'},
                                     'ports': [],
                                     'hostnames': [],
                                     'os': [],
                                     'updated': datetime.datetime.utcnow(),
                                     'oids': oidList[ipaddress]})
                else:
                    db.hosts.update_one({'ip': ipaddress},
                                        {'$set': {'updated': datetime.datetime.utcnow(),
                                                  'oids': oidList[ipaddress]}})

    infile.close()  # we're done

main()
