#!/bin/bash
set -e

import_url_params=""
should_import=true

export_url_params=""
should_export=true
export_url_path=""
export_archive=false

has_not_imported_or_exported=true

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

if [ ! -z $export_format ] ; then
    export_url_params="${export_url_params} --data-urlencode format=${export_format}"
fi

if [ ! -z $export_filter ] ; then
    export_url_params="${export_url_params} --data-urlencode filter=${export_filter}"
fi

if [ ! -z $export_index ] ; then
    export_url_params="${export_url_params} --data-urlencode index=${export_index}"
fi

if [ ! -z $export_source ] ; then
    export_url_params="${export_url_params} --data-urlencode source=${export_source}"
fi

if [ ! -z $export_fallback ] ; then
    export_url_params="${export_url_params} --data-urlencode fallback=${export_fallback}"
fi

if [ ! -z $export_order ] ; then
    export_url_params="${export_url_params} --data-urlencode order=${export_order}"
fi

if [ ! -z $export_printf ] && [ "$export_printf" != "default" ] ; then
    export_url_params="${export_url_params} --data-urlencode printf=${export_printf}"
fi

if [ ! -z $export_charset ] ; then
    export_url_params="${export_url_params} --data-urlencode charset=${export_charset}"
fi

if [ ! -z $export_breaks ] ; then
    export_url_params="${export_url_params} --data-urlencode breaks=${export_breaks}"
fi

if [ ! -z $export_no_comments ] ; then
    export_url_params="${export_url_params} --data-urlencode no-comments=${export_no_comments}"
fi

if [ ! -z $export_no_folding ] ; then
    export_url_params="${export_url_params} --data-urlencode no-folding=${export_no_folding}"
fi

if [ ! -z $export_namespace ] ; then
    export_url_params="${export_url_params} --data-urlencode namespace=${export_namespace}"
fi

if [ ! -z $export_status ] ; then
    export_url_params="${export_url_params} --data-urlencode status=${export_status}"
fi

if [ ! -z $export_path ] ; then
    export_url_params="${export_url_params} --data-urlencode path=${export_path}"
fi

if [ -z $import_file_path ] ; then
    echo "Not importing anything because the path to the import file has not been set."
    should_import=false
fi

if [ "$should_import" = true ] && [ -z $import_file_ext ] ; then
    echo "Not importing anything because the extension of the import file has not been set."
    should_import=false
fi

if [ -z $export_file_ext ] ; then
    echo "Not exporting anything because the extension of the export file has not been set."
    should_export=false
fi

if [ "$should_export" = true ] && [ -z $export_file_path ] ; then
    echo "Not exporting anything because the path to the export file has not been set."
    should_export=false
fi

if [ "$should_export" = true ] && [[ $export_file_ext == all* ]] ; then
    export_url_end=$(echo $export_file_ext| cut -b5-)
    export_url_path=$"all.${export_url_end}"
    download_path="${export_file_path}"
fi

if [ "$should_export" = true ] && [[ $export_file_ext == archive* ]] ; then
    export_archive=true
    export_url_end=$(echo $export_file_ext| cut -b9-)
    export_url_path="archive/${export_url_end}.zip"

    mkdir -p "downloads"
    download_path="downloads/Loco.zip"

    if [ ! -d "$export_file_path" ]; then
        echo "export_file_path directory does not exist, creating..."
        mkdir -p "$export_file_path"
    fi
fi

if [ "$should_export" = true ] && [[ $export_file_ext == locale* ]] ; then

    if [ -z $export_locale ] ; then
        echo "Not exporting anything because the locale of the export file has not been set but the export extension set is locale."
        should_export=false
    else
        export_url_end=$(echo $export_file_ext| cut -b8-)
        export_url_path=$"locale/${export_locale}.${export_url_end}"
        download_path="${export_file_path}"
    fi

fi

if [ "$should_import" = true ] ; then
    echo "Importing your assets to Loco..."
    curl -f -s -u $loco_api_key: -d @$import_file_path "https://localise.biz/api/import/${import_file_ext}${import_url_params}"
    has_not_imported_or_exported=false
fi

if [ "$should_export" = true ] ; then
    echo "Exporting your assets from Loco..."
    curl -f -G -s -u $loco_api_key: -o $download_path $export_url_params "https://localise.biz/api/export/${export_url_path}" 
    has_not_imported_or_exported=false

    if [ "$export_archive" = true ] ; then
        unzip -qq -o -u "$download_path" -d unarchived/
        cp -r unarchived/ "$export_file_path"
    fi

fi

if [ "$has_not_imported_or_exported" = true ] ; then
    echo "Step did not do anything."
    exit 1
fi

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
