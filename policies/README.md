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

The subfolders are:

* **root**: use these policies sparingly, as they make your system wide open
* **topic-open**: use these policies if you're working with a fairly small implementation, and you want all things to be able to do everything
* **topic-restricted**: use these policies if you want to restrict Things from accessing things outside their "group" (see Topics below)
* **topic-individual**: use these policies if you want to restrict Things to accessing only their own stuff

In general I'm working with the principal that you should nail down stuff as much as possible.
If you're creating a sensor that only can post thing and never can receive messages,
it should not have the ability to subscribe to a message thing

Because topic access control is tied to certicates, note:

* if you use **topic-restricted**, assume that all the Things with the "group" share the same X.509 certficate
* if you use **topic-individual**, assume that every Thing will have its own X.509 certificate

These can be mixed and matched, i.e. some things can be more nailed down than others. Obviously creating 
X.509 certificates for each thing is more work.

## Topics

We suggest the following topic organization.

* Layer 1 : the name of your organization
* Layer 2 : the code for a particular "group" of things
* Layer 3 : a version, always 01 
* Layer 4 : the Thing ID

For example,

    ibm/lighting/01/l38939339

This seems to provide a fairly flexibly upgrade path to very complicated networks.

The actual readings can be in the payload, though you can add additional layers like:
    
    ibm/lighting/01/l38939339/ambient-noise

though personally I don't think this is a great idea.

