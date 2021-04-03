# Introduction

## Example deployment
This example deploys a new Azure firewall resource into an existing subnet (found using the Data Lookup resource) with 2 network rule collections. One rule collection deploys a set of ALLOWED rules and another rule collection for all DENY traffic.

Each rule collection requires 1 azurefirewall-net-rule-collection module to be called. 

A Rule collection can contain multiple related rules (for example all ALLOW or all DENY rules).