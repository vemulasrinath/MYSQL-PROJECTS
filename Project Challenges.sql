/* Finding 5 oldest users */

SELECT ID, USERNAME, CREATED_AT
FROM users
ORDER BY CREATED_AT ASC;
**********************************************
SELECT * FROM users
    ORDER BY created_at
    LIMIT 5;
**********************************************

/**
 * We need to figure out when to schedule an ad campaign.
 * What days of the week do most users register on?
 **/

SELECT
    DAYNAME(created_at) AS day_of_the_week,
    COUNT(*) AS total_count
FROM users
GROUP BY day_of_the_week
ORDER BY total_count DESC;

***************************************************

/**
 * We want to target our inactive users with an email campaign.
 * Find the users who have never posted a photo?
 **/

SELECT
	users.id,
    username,
    users.created_at as user_joining_date
FROM users
    LEFT JOIN photos
        ON users.id = photos.user_id
    WHERE photos.user_id IS NULL;

************************************************************

/**
 * We are running a new contest to see who can get the most likes on a single photo.
 * Find out who won the contest? 🙌
 **/

SELECT
    users.id AS user_id,
    username,
	photos.id AS photo_id,
    photos.image_url,
    COUNT(*) AS total_likes_count
FROM photos
    JOIN likes
        ON photos.id = likes.photo_id
    JOIN users
        ON users.id = photos.user_id
    GROUP BY photos.id
    ORDER BY total_likes_count DESC
    LIMIT 1;
*************************************************************************


/**
 * Our Investors would like to know...
 * How many times does the average user post?
 **/

SELECT
    ROUND(
        ( SELECT COUNT(*) FROM photos ) / ( SELECT COUNT(*) FROM users ),
        2
    ) AS avg_user_post;
***************************************************************************

/**
 * A Brand wants to know which hashtags to use in a Post.
 * What are the Top 5 most commonly used hashtags?
 **/

SELECT
    tags.id AS tag_id,
    tags.tag_name,
    COUNT(*) as total_tags_count
FROM tags
    JOIN photo_tags
        ON tags.id = photo_tags.tag_id
    GROUP BY tags.id
    ORDER BY total_tags_count DESC
    LIMIT 5;
***********************************************************************************

/**
 * We have a small problem with bots on our site...
 * Find number of users who have liked every single photo on the site?
 **/

SELECT
    users.id AS user_id,
    users.username,
    COUNT(*) AS total_user_likes
FROM users
    JOIN likes
        ON users.id = likes.user_id
    GROUP BY users.id
    HAVING total_user_likes = (
        SELECT COUNT(*) FROM photos
    );