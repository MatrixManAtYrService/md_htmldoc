#!/usr/bin/env bash
ORIG=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/scripts/vercomp.sh

command -v pandoc >/dev/null 2>&1 || { echo >&2 "This script requires pandoc but it's not installed. Aborting."; exit 1; }
command -v python >/dev/null 2>&1 || { echo >&2 "This script requires python but it's not installed. Aborting."; exit 1; }

# Testing python3 panflute version
if [[ $(pip3 show panflute) =~ Version:\ ([0-9.]+) ]]; then
  check_min_ver "python3 panflute" "2.1.0" ${BASH_REMATCH[1]}
else
  echo "No python3 panflute found. Please install a recent version and try again. Aborting."
  exit 1
fi

cd $DIR

# set marker to know if another instance starts meanwhile (and abort this run in that case)
touch .script_running
STARTTIME=$(stat -c %y .script_running)
NOWTIME=$(stat -c %y .script_running)

# make way for html
HTML_DIR=$(basename $(dirname $DIR))_htmldoc
rm --interactive=once -rf ../${HTML_DIR}
mkdir -p ../${HTML_DIR}

# mimic parent repo's directory structure in ../$HTML_DIR
PARENT_REPO_CACHED_FILES=$(cd .. && git ls-files)

echo copying directory structure...
for i in ${PARENT_REPO_CACHED_FILES[@]} ; do
    NOWTIME=$(stat -c %y .script_running) ; if [[ $STARTTIME != $NOWTIME ]] ; then echo ABORTING, another instance started meanwhile && exit ; fi

    FROM="../$(dirname $i)"
    TO="../$HTML_DIR/$(dirname $i)"
    if [[ ! -d "$TO" ]]
    then
        printf "    %35s" "$FROM"
        printf "  --mkdir-->"
        printf "    %35s\n" "$TO"
        mkdir -p "$TO"
    fi
done

# discover docs in parent repo
PARENT_REPO_DOCUMENTATION=$(find .. -name .git -prune -o -name md_htmldoc -prune -o -iname "*.md" -print)
readarray -t DOC_RELEVANT<<<$($DIR/get_references.py "$PARENT_REPO_DOCUMENTATION" | tr -d '\r')

# for each documentation-relevant file
echo extracting docs...
for i in "${DOC_RELEVANT[@]}" ; do
    NOWTIME=$(stat -c %y .script_running); if [[ $STARTTIME != $NOWTIME ]] ; then echo ABORTING, another instance started meanwhile && exit ; fi

    FROM=$i
    TO=${i/\.\./../$HTML_DIR}

    if [[ $i == *.md ]] ; then
        # generate html, replacing .md links with .html links
        printf "    %35s" $FROM
        printf " --pandoc--> "
        printf "%-35s\n" ${TO/\.md/.html}
        pandoc -s "$FROM" --mathjax --filter link_filter.py -o "${TO/\.md/.html}"
    else
        # copy hyperlinked files
        printf "    %35s" $FROM
        printf " ----cp----> "
        printf "%-35s\n" $TO
        cp "$FROM" "$TO"
    fi
done

# in the parent repo, .gitignore HTML_DIR unless it is already .gitignored
touch ../.gitignore
grep -q -F "${HTML_DIR}/" ../.gitignore || echo "${HTML_DIR}/" >> ../.gitignore

# clean up any empty directories we may have created
find ../$HTML_DIR -type d -empty -delete

echo Done! Enjoy your HTML files.

rm .script_running
cd $ORIG
