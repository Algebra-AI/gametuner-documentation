# Game Tuner

Welcome to Game Tuner documentation!

Game Tuner is multi-faceted product and this comprehensive documentation aims at teaching you everything you need to know about all the aspects of the product. Most of the users will not need to use all the aspects of the product and that's fine. Analytics is a team sport. At the bottom you will find guideliness based on different roles. You are advised to start from there.m

## What is Game Tuner

It's like having your internal modern data platform out of the box that comes with preset BI tool and integrations.

__What does this mean?__

First of all, the product is in big part a Data-Platform-as-a-Service. 
- You get lightweight and robust tracking SDK. 
- Data is streamed in real-time. 
- Offline / late data is handled.
- Data is deduplicated, quality-checked and labeled accordingly.
- Data is modeled before being used downstream.
- There is custom Semantic Layer with 150+ out of box metrics and significant extensibility

There is no one tool that fits all analytics needs (out of box). Sooner or later you will need to do some custom work on the pipelines, you will need custom data model etc.

Unlike many analytics solutions out there, we have opted out of trying to fit everyone's needs and instead focused on satisfying one business vertical. We focused on satisfying the whole business vertical needs in Mobile Gaming, an area where the team behind the product has extensive experience. 

We know some products will run offline and send telemetry hours if not days after it was created. It's something that we will handle. Unique ID for multi-device users, we will handle it. We actually do data modelling that's based on 10 years of experience doing user analytics. You can get direct access to both your telemetry data __and__ modelled data. Considering everything is built on top of [GCP](https://cloud.google.com/), you will immidaitelly get the equivalent of end result of internal Data team building something for a year-or-so.

### BI and Analytics

On top of Data Platform we have developed BI and Analytics tools that are aimed at solving most of everyday needs. As for everything, Pareto reigns supreme in product analytcs as well - 80% of effort will produce 20% of value. This is the first 80% effort needed to set up everything and start building reports and tracking business. Unfortunatelly, many organizations get stuck here, making this 20% into 100% of value they produce. We want to make this as easy as possible __and__ to enable organizations to go beyond. Why should an analyst spend days building a report if anyone from the team is empowered to build it for themselves, spending only a fraction of analyst's time on consultation. Instead, an analyst can focus on work that's can create added value for that specific product.

We have created a self-serving BI tool with acompanying set of tools that help facilitate: 
- better data quality on the very source (telemetry implementation)
- better knowledge dissemination
- easier data modeling

### Integrations

The first external data set that we offer as a separate _data source_ is AppsFlyer data. You need to have account with AppsFlyer and with a simple config start ingesting AF data into the Data Platform. There's also an out-of-box modelling layer for AF data that's used downstream, and AF data can be used side-by-side with game telemetry.

For In App Purchases we also handle currency conversion and to an extent tax and game store cut to produce Net Revenue.

## Looking beyond

The product is still in it's early days. We aim to become one stop solution for Data Platform and Analytics.

## Where to start?

Developers

- [Telemetry Setup](./man/TelemetrySetup.md)
- [Eventory](./man/Eventory.md)

Analysts

- [BI Tool](./man/BITool.md)
- [Stories](./man/Stories.md)
- [Eventory](./man/Eventory.md)
- [Semantic Layer](./man/SemanticLayer.md)
