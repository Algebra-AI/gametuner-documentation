Tables:
- `user_history` - full one row: one days for one user table tracking all the changes to user properties
- `daily_user_history` - one row: one day for one user, but only if a user is active on that day
- trimmed tables: can have reduced values along one dimension
	+ example: a user_history like table that has cohort_day values only for specific days; used only when filter is used on that dimension that match givven values
- `registration_user_history` - holds only values for cohort_day = 0
- `snapshot_user_history` - optimization technique for storage; could remove the need for full `user_history` and be used for rewinding and calculating totals on-the-fly
	+ Example: let us store only UH partitions for even dates. Using that, registration_user_history and daily_user_history, you can recontruct UH for odd dates, on-the-fly, or easily materialize it
