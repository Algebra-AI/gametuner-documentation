## Getting Started

Semantic Layer is pre-set for every new Game Tuner project. This documentation will provide an introduction about the inner workings of GT Semantic Layer and continue into how you can expand the entities defined by the Semantic Layer.

## Datasources

Basic entity is a `Datasource`. Some are built-in, some are provided by out-of-the-box integrations with external data sources and you can set up your custom datasources, as well.

For most user-facing applications, including mobile games, the most important analytics is about user-level KPIs. For this purpose Game Tuner defines a Datasource called `User Entity`.

### User Entity

This is the primary datasource which is "special" in many ways. Semantic Layer is closely coupled with [Data Model](DataModel.md) and Query Engine. User Entity has more built in options than any other Datasource.

The centerpiece of the User Entity is the table that tracks various `User Properties` for each user for each day. This is accompanied by all the user-generated events.




Tables:
- `user_history` - full one row: one days for one user table tracking all the changes to user properties
- `daily_user_history` - one row: one day for one user, but only if a user is active on that day
- trimmed tables: can have reduced values along one dimension
	+ example: a user_history like table that has cohort_day values only for specific days; used only when filter is used on that dimension that match givven values
- `registration_user_history` - holds only values for cohort_day = 0
- `snapshot_user_history` - optimization technique for storage; could remove the need for full `user_history` and be used for rewinding and calculating totals on-the-fly
	+ Example: let us store only UH partitions for even dates. Using that, registration_user_history and daily_user_history, you can recontruct UH for odd dates, on-the-fly, or easily materialize it

#### User Properties

Defining user properties...

*TODO*
...
...
...


### Other Sources

*TODO*
...
...
...


## Problems

## `Registrations` or the number of installs

#### We can calculate this easiely with the `User History` data structure. The formula is simply:

```sql
select
	date_,
	sum(dau) as registrations
	-- or sum(cohort_size) as registrations
	-- there can be some small difference
from main.user_history
where cohort_day = 0
group by 1
```

or in our config:

```yaml
registrations:
  label: Registrations
  x:
      select_statement: SUM({dau})
      where: cohort_day = 0
  kpi: x
  total: sum(x)
```

But the problem with this definition is that it works only for daily metrics. In a cohort view, we need to have different approach. There are several things we can do:

We can have different definition for `Registration` as a cohort metric. We can do:

```sql
select
	cohort_day,
	sum(cohort_size) as registrations
from main.user_history
group by 1
```

or in yaml config format:

```yaml
registrations: # cohorted
  label: Registrations
  x:
      select_statement: SUM({cohort_size})
  kpi: x
  total: sum(x)
```

Which is vastly different and can't work interchangeably. Another problem is that this way of computing "registrations over cohort day" is insane waste of resources. Basically, we'd need to use full User History table, always, for something that clearly can be computed much easier if we only allow it.

#### We can use simple heuristics


Heuristic is, and this is a bit silly to write, `Registration(cohort_day = N)` = `Registration(cohort_day = 0`. Using this we can do couple of things. We can either hard-code this heuristic for `Registrations` and other similar KPIs (and theres very few of them, one is `UA Spend`) or we can explilicitly define a function that does something like it, eg. `f(x) = expand_in_cohort_time(x) = f(0)`. It will require more complex behavior for bundling multiple cohorts, but something along those lines.

- If we hard code this, then we can leave config as is.

- If we want to explicitly define this behavior, then we need to redefine how we write config.

Now, if we have different config for daily and cohort metrics, then we can all sorts of other things. We can use it to define what's shown in the highlight numbers, or anything else that could be specific for those sort of KPIs.

##### Further optimization

Now, if we are doing any of this, there's a simple optimization for `Registrations` metric, which is often one of the most used ones, as it's used in `Retention`, `LTV` and similar cohort KPIs.
Let's say we have a clean structure that corresponds to a query:

```sql
select
	*
from main.user_history
where cohort_day = 0
```

and let it exist in `main.registration` table. This structure will have identical values for `date_` and `registration_date`. A querry run agains this structure will yeald the same result as the first formula, but will be computationally much less expensive. Next step is either one of implicit expanding of the KPI defined only for d0 to other cohort days, or the one where we do it explicitly, as defined in the config.

## `DAU` totals and irregular dimensions

Let's start with a structure that has *regular* dimensions, which means that if we break up `DAU`, for instance, by any of dimensions and then sum it up, we'll get the same result. Now there's still the question of how `DAU` should behave when we set time grain to something other than a `day`, eg. `week`. The question is: _What is weekly `DAU`?_ One could say this is not defined, but implicitly, it's not something we intuitivelly believe. It makes sense to say that weekly `DAU` is an average of daily `DAU` KPI. That would make `date` dimension irregular in respect to `DAU`, but weekly `Revenue` is still *sum* of daily `Revenue`, which makes `date` a proper dimension in respect to `Revenue` KPI.

To make things more complicated, let's look at `ARPDAU`, which is calculated by the formula:
`SUM(Revenue) / SUM(DAU)`.

Weekly `ARPDAU` is still calculated as `SUM(Revenue) / SUM(DAU)`, which makes `date` a proper dimension for `DAU` in this context.

There's a few options here:

- either we dismiss the notion that weekly `DAU` is an average, and continue using the sum for it, as well, albeit it creates non-intuitive metric
- or we need to accomodate this special behavior at the KPI level, while clearly distinguishing `DAU` as a KPI and `dau` as a building block for other metrics.


### Irregular dimensions

We can expand the notion of irregular dimensions to, eg. `platform`. Unlike `registration_platform`, which is fixed by the act of the first log in, platform can be different for every sesion. SUM(`DAU`(`platform`)) > `DAU`, which makes it irregular dimension in respect to `DAU` and requres special handling, if we want to allow it. This could, potentially, be solved by going one step deeper on granularity level and creating something like `Level User History`, aka some sort of User Journey data source, which would allow easier, and correct, computation of metrics at this level. Or we can define special set of rules for irregular metrics, but that can be one deep rabbit hole...








## Conclusions

Separate definition of Daily from Cohort KPIs.

