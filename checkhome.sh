#! /bin/bash

PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BROWN='\033[0;33m'
NC='\033[0m'
dir='/home'

printf '[Log checkhome]\n'

# 1. Kiem tra file tao moi

cd "${dir}" || exit 1
mkdir -p HANDLED || exit 1
chown -hR root HANDLED/
chmod 700 HANDLED/
printf '%b=== Danh sach file tao moi ===\n' ${PURPLE}
for file in *
do
	[ "$file" = "HANDLED" ] && continue

	[ -h "HANDLED/$file" ] && continue

	printf '%b%s%b\n' ${CYAN} "$file" ${NC}
	head -10 $file

	ln -s "../$file" "HANDLED/$file"

done

# 2. Kiem tra file sua doi

cd "${dir}" || exit 1
touch checksum.txt || exit 1
chown root checksum.txt
chmod 600 checksum.txt
printf '%b=== Danh sach file sua doi ===\n' ${PURPLE}
for file in *
do
	[ "$file" = "checksum.txt" ]  && continue
	[ -d "$file" ] && continue
	if test "$(grep $(md5sum $file | awk '{printf "%s\n",$1}') checksum.txt)" == ""
	then
		printf '%b%s%b\n' ${CYAN} "$file" ${NC} 
		md5sum $file | awk '{printf "%s\n",$1}' >> checksum.txt
	fi
done

# 3. Kiem tra file bi xoa

mkdir -p "${dir}/HANDLED" || exit 1
chown -hR root HANDLED/
chmod 700 HANDLED/
cd "${dir}/HANDLED" || exit 1
printf '%b=== Danh sach file bi xoa ===\n' ${PURPLE}

for file in *
do
	[ -f "$file" ] && continue
	printf '%b%s\n' ${CYAN} "$file"
	rm "$file" || exit 1
done

printf '%b=========================================%b\n\n' ${BROWN} ${NC}

