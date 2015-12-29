# Policies

Here's some useful policies for your AWS IoT implementation.
Policies are basically access control rules.

## Tools

Use, e.g. 
    
    $ sh AddPolicy.sh topic-open/AllowAllIoTConnectSubscribe.json

to add a policy to AWS. The policy will be named the same as the file,
with some obvious substitutions. 

You need to have your AWS IoT command line tools set up before this will work.

You can get help about parameterization by doing

    $ sh AddPolicy.sh --help

## Folders

See [top level README](../../README.md) for a description of the Topics

The subfolders are:

* **root**: use these policies sparingly, as they make your system wide open
* **topic-open**: use these policies if you're working with a fairly small implementation, and you want access to everything (e.g. "ibm/#")
* **topic-group**: use these policies if you want to restrict access to a group (e.g. "ibm/canada/#")
* **topic-scope**: use these policies if you want to restrict to a scope (e.g. "ibm/canada/+/l38939339")

In general I'm working with the principal that you should nail down stuff as much as possible.
If you're creating a sensor that only can post thing and never can receive messages,
it should not have the ability to subscribe to a message thing

Because topic access control is tied to certicates, note:

* if you use **topic-group**, assume that all the Accessors with the "group" share the same X.509 certficate
* if you use **topic-scope**, assume that every Accessors will have its own X.509 certificate

These can be mixed and matched, i.e. some things can be more nailed down than others. Obviously creating 
X.509 certificates for each Accessor is more work.
