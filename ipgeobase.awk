#!/usr/bin/awk -f
@include "regions.awk"
BEGIN {
	system("cp geo_files.zip geo_files.bak 1>&2");
	system("wget -N http://ipgeobase.ru/files/db/Main/geo_files.zip 1>&2");
	system("unzip -ox geo_files.zip cities.txt cidr_optim.txt 1>&2");
        print "CREATE TABLE IF NOT EXISTS ipgb_cities (";
        print " `id` INT PRIMARY KEY,"
        print " `city` VARCHAR(128),"
        print " `region` VARCHAR(128),"
        print " `region_code` INT,"
        print " `fdistrict` VARCHAR(128),"
        print " `lat` DOUBLE,"
        print " `lon` DOUBLE) CHARACTER SET utf8;"

        print "CREATE TABLE IF NOT EXISTS ipgb_cidr (";
        print " `start` INT UNSIGNED PRIMARY KEY,"
        print " `end` INT UNSIGNED UNIQUE NOT NULL,"
        print " `desc` VARCHAR(128),"
        print " `country` VARCHAR(8),"
        print " `city_id` INT,"
        print " KEY se (start, end)) CHARACTER SET utf8;"

        print "DELETE FROM ipgb_cidr;";
        print "DELETE FROM ipgb_cities;";
        # id, город, регион, округ, широта, долгота
        pream="INSERT INTO ipgb_cities VALUES";
        i=0;
        FS="\t";
        print pream;
        while (("iconv -f cp1251 -t utf8 cities.txt" | getline) > 0) {
            if (notfirst) printf ",\n"
            regcode = Regs[$3];
            if (!regcode) regcode="NULL";
            printf " (%d, '%s', '%s', %s, '%s', %s, %s)", $1, $2, $3, regcode, $4, $5, $6;
            notfirst=1;
            i+=1;
            if (i==200) {
                i=0;
                notfirst=0;
                printf ";\n";
                print pream;
            }
        }
        printf ";\n";
        close("iconv -f cp1251 -t utf8 cities.txt")

        # start, end, text, country, city_id
        pream="INSERT INTO ipgb_cidr VALUES";
        print pream;

        notfirst=0;
        i=0;
        while (("iconv -f cp1251 -t utf8 cidr_optim.txt" | getline) > 0) {
            if (notfirst) printf ",\n"
            if ($4 == "-") $4="";
            if ($5 == "-") $5=0;
            printf " (%s, %s, '%s', '%s', %d)", $1, $2, $3, $4, $5;
            notfirst=1;
            i+=1;
            if (i==200) {
                i=0;
                notfirst=0;
                printf ";\n";
                print pream;
            }
        }
        printf ";\n";
        close("iconv -f cp1251 -t utf8 cidr_optim.txt")

}
