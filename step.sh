#!/bin/bash
set -e

import_url_params=""

if [ -z $import_file_path ] ; then
    echo "Not importing anything"
    exit 1
fi

if [ ! -z $import_index ] ; then
    import_url_params="${import_url_params}?index=${import_index}"
fi

if [ ! -z $import_locale ] ; then
    import_url_params="${import_url_params}&locale=${import_locale}"
fi

if [ ! -z $import_async ] ; then
    import_url_params="${import_url_params}&import_async=${import_async}"
fi

if [ ! -z $import_source_path ] ; then
    import_url_params="${import_url_params}&path=${import_source_path}"
fi

if [ ! -z $import_ignore_new ] ; then
    import_url_params="${import_url_params}&ignore-new=${import_ignore_new}"
fi

if [ ! -z $import_ignore_existing ] ; then
    import_url_params="${import_url_params}&ignore-existing=${import_ignore_existing}"
fi

if [ ! -z $import_delete_absent ] ; then
    import_url_params="${import_url_params}&delete-absent=${import_delete_absent}"
fi

if [ ! -z $import_tag_new ] ; then
    import_url_params="${import_url_params}&tag-new=${import_tag_new}"
fi

if [ ! -z $import_tag_all ] ; then
    import_url_params="${import_url_params}&tag-all=${import_tag_all}"
fi

if [ ! -z $import_untag_all ] ; then
    import_url_params="${import_url_params}&untag-all=${import_untag_all}"
fi

if [ ! -z $import_tag_updated ] ; then
    import_url_params="${import_url_params}&tag-updated=${import_tag_updated}"
fi

if [ ! -z $import_untag_updated ] ; then
    import_url_params="${import_url_params}&untag-updated=${import_untag_updated}"
fi

if [ ! -z $import_tag_absent ] ; then
    import_url_params="${import_url_params}&tag-absent=${import_tag_absent}"
fi

if [ ! -z $import_untag_absent ] ; then
    import_url_params="${import_url_params}&untag-absent=${import_untag_absent}"
fi

curl -u $loco_api_key: -d @$import_file_path "https://localise.biz/api/import/${import_file_ext}${import_url_params}"

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
