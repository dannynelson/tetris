# Grunt Like Meteor

Grunt build file that functions similarly to meteor JS

## Structure

Three main directories. 

- client/ - code that runs on client
- server/ - code that runs on server
- lib/ - code that can be shared between both

index files should be in the root of each directory, and are the entry point for other files

All templates will be appended to index.html.

Default client asset management is Coffeeify.
