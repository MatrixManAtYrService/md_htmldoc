#!/usr/bin/env bash
ORIG=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# make way for html
HTML_DIR=$(basename $(dirname $(pwd)))_htmldoc
rm --interactive=once -rf ../${HTML_DIR}
mkdir -p ../${HTML_DIR}

# mimic parent repo's directory structure in ../$HTML_DIR
PARENT_REPO_CACHED_FILES=$(cd .. && git ls-files)
for i in ${PARENT_REPO_CACHED_FILES[@]} ; do mkdir -p ../$HTML_DIR/$(dirname $i); done

# discover docs in parent repo
PARENT_REPO_DOCUMENTATION=$(find .. | egrep '\.md$' | egrep -v '\./md_htmldoc')
DOC_RELEVANT=$(python $DIR/get_references.py $PARENT_REPO_DOCUMENTATION)

# for each documentation-relevant file
for i in ${DOC_RELEVANT[@]} ; do

    FROM=$i
    TO=${i/\.\./../$HTML_DIR}

    if [[ $i == *.md ]] ; then
        # generate html, replaicng .md links with .html links
        printf "%35s" $FROM
        printf " --pandoc--> " $FROM
        printf "%-35s\n" ${TO/\.md/.html}
        pandoc -s $FROM --filter link_filter.py -o ${TO/\.md/.html}
    else
        # copy hyperlinked files
        printf "%35s" $FROM
        printf " ----cp----> " $FROM
        printf "%-35s\n" $TO
        cp $FROM $TO
    fi
done

# in the parent repo, .gitignore HTML_DIR unless it is already .gitignored
touch ../.gitignore
grep -q -F "${HTML_DIR}/" ../.gitignore || echo "${HTML_DIR}/" >> ../.gitignore

cd $ORIG
