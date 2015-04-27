UPDATE users SET weekly_trophies = 0;
DELETE FROM battles WHERE retain = 'f' AND created_at < current_timestamp + interval '14 days';
