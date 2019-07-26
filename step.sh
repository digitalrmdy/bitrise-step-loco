#!/bin/bash
set -e

url_params=""

if [ -z $file_path ] ; then
    echo "Not importing anything"
    exit 1
fi

if [ ! -z $index ] ; then
    url_params="${url_params}?index=${index}"
fi

if [ ! -z $locale ] ; then
    url_params="${url_params}&locale=${locale}"
fi

if [ ! -z $async ] ; then
    url_params="${url_params}&async=${async}"
fi

if [ ! -z $source_path ] ; then
    url_params="${url_params}&path=${source_path}"
fi

if [ ! -z $ignore_new ] ; then
    url_params="${url_params}&ignore-new=${ignore_new}"
fi

if [ ! -z $ignore_existing ] ; then
    url_params="${url_params}&ignore-existing=${ignore_existing}"
fi

if [ ! -z $delete_absent ] ; then
    url_params="${url_params}&delete-absent=${delete_absent}"
fi

if [ ! -z $tag_new ] ; then
    url_params="${url_params}&tag-new=${tag_new}"
fi

if [ ! -z $tag_all ] ; then
    url_params="${url_params}&tag-all=${tag_all}"
fi

if [ ! -z $untag_all ] ; then
    url_params="${url_params}&untag-all=${untag_all}"
fi

if [ ! -z $tag_updated ] ; then
    url_params="${url_params}&tag-updated=${tag_updated}"
fi

if [ ! -z $untag_updated ] ; then
    url_params="${url_params}&untag-updated=${untag_updated}"
fi

if [ ! -z $tag_absent ] ; then
    url_params="${url_params}&tag-absent=${tag_absent}"
fi

if [ ! -z $untag_absent ] ; then
    url_params="${url_params}&untag-absent=${untag_absent}"
fi

curl -u $loco_api_key: -d @$file_path "https://localise.biz/api/import/${file_ext}${url_params}"

#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
# envman add --key EXAMPLE_STEP_OUTPUT --value 'the value you want to share'
# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
