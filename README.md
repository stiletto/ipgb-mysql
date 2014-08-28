ipgb-mysql
==========

ipgb-mysql is a simple script for converting text databases
of Russian and Ukrainian CIDRs from ipgeobase.ru to SQL (MySQL).

# How to use the script

    $ chmod +x ipgeobase.awk
    $ ./ipgeobase.awk > ipgb.sql
    $ mysql
    mysql> use somedatabase;
    mysql> \. ipgb.sql

# How to query resulting database

    $ php -r 'print(ip2long("213.180.204.11")."\n");'
    3585395723
    $ mysql
    mysql> use somedatabase;
    mysql> select country,city,region,region_code,fdistrict,lat,lon from ipgb_cidr left join ipgb_cities on ipgb_cidr.city_id = ipgb_cities.id
        -> where (start <= 3585395723) and (end >= 3585395723) limit 1;
    +---------+--------------+--------------+-------------+----------------------------------------------------------+-----------+-----------+
    | country | city         | region       | region_code | fdistrict                                                | lat       | lon       |
    +---------+--------------+--------------+-------------+----------------------------------------------------------+-----------+-----------+
    | RU      | Москва       | Москва       |          48 | Центральный федеральный округ                            | 55.755787 | 37.617634 |
    +---------+--------------+--------------+-------------+----------------------------------------------------------+-----------+-----------+
    1 row in set (0.00 sec)

Region codes are FIPS 10-4 codes for compatibility with MaxMind's GeoIP database. Don't confuse them with Russian vehicle regional codes.

Be this code public domain.
