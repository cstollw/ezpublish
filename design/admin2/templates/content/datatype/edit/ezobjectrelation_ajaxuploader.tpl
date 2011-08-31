{if ezmodule( 'ezjscore' )}
    <input type="submit" value="{'Upload a file'|i18n( 'design/admin2/content/datatype' )}"
            name="RelationUploadNew{$attribute.id}-{$attribute.version}"
            class="button simple-relation-upload-new hide"
            {cond( $enabled, '', 'disabled="disabled"' )}
            title="{'Upload a file to create a new object and add it to the relation'|i18n( 'design/admin2/content/datatype' )}" />

    {run-once}
    {ezscript_require( 'ezjsc::yui3', 'ezjsc::yui3io', 'ezmodalwindow.js', 'ezajaxuploader.js' )}
    <div id="relation-modal-window" class="modal-window" style="display:none;">
        <h2><a href="#" class="window-close">{'Close'|i18n( 'design/admin/pagelayout' )}</a><span></span></h2>
        <div class="window-content"></div>
    </div>
    <script type="text/javascript">
    {literal}
    (function () {
        var uploaderConf = {
            target: {},
            open: {
                action: 'ezajaxuploader::uploadform::ezobjectrelation'
            },
            upload: {
                action: 'ezajaxuploader::upload::ezobjectrelation',
                form: 'form.ajaxuploader-upload'
            },
            location: {
                action: 'ezajaxuploader::preview::ezobjectrelation',
                form: 'form.ajaxuploader-location',
                browse: 'div.ajaxuploader-browse',
    {/literal}
                required: "{'Please choose a location'|i18n( 'design/admin2/content/datatype' )|wash( 'javascript' )}"
    {literal}
            },

            preview: {
                form: 'form.ajaxuploader-preview',

                // this is the eZAjaxUploader instance
                callback: function () {
                    var box = this.Y.one('#ezobjectrelation_browse_' + this.conf.target.ObjectRelationsAttributeId),
                        table = box.one('table.list');
                        tbody = box.one('table.list tbody'),
                        tds = tbody.get('children').slice(-1).item(0).get('children');
                        result = this.lastMetaData;

                    table.removeClass('hide');
                    tds.item(0).setContent(result.object_info.name);
                    tds.item(1).setContent(result.object_info.class_name);
                    tds.item(2).setContent(result.object_info.section_name);
                    tds.item(3).setContent(result.object_info.published);

                    box.one('input[name*=_data_object_relation_id_]').set('value', result.object_info.id);
                    box.one('.ezobject-relation-remove-button').removeClass('button-disabled').addClass('button').set('disabled', false);
                    box.all('.ezobject-relation-no-relation').addClass('hide');
                    box.one('.ezobject-relation-add-button').addClass('button-disabled').set('disabled', true);
                    box.one('.simple-relation-upload-new').addClass('button-disabled').set('disabled', true);

                    this.modalWindow.close();
                }
            },
    {/literal}
            title: "{'Upload a file and add the resulting object in the relation'|i18n( 'design/admin2/content/datatype' )|wash( 'javascript' )}",
    {literal}

            // validation, error settings
            requiredInput: 'input.input-required',
            labelErrorClass: 'message-error',
            validationErrorText: "Some required fields are empty.",
            validationErrorTextElement: '.ajaxuploader-error',
            errorTemplate: '<div class="message-error">%message</div>',

            loading:{
                opacity: 0.2,
                loader: "#ajaxuploader-loader",
                zIndex:51
            }
        };

        var windowConf = {
            window: '#relation-modal-window',
            content: '.window-content',
            close: '.window-close, .window-cancel',
            title: 'h2 span',
            width: 650,
            centered: false,
            xy: ['centered', 50],
            zIndex: 50,
            mask: '#overlay-mask'
        };

        YUI().use('node', 'overlay', 'dom-base', 'io-ez', 'io-form', 'io-upload-iframe', 'json-parse', function (Y) {
            Y.on('domready', function() {
                var win = new eZModalWindow(windowConf, Y),
                    tokenNode = Y.one('#ezxform_token_js');

                Y.all('.simple-relation-upload-new').each(function () {
                    var data = this.get('name').replace("RelationUploadNew", '').split("-"),
                        conf = Y.clone(uploaderConf, true),
                        uploader;

                    conf.target = {
                       ObjectRelationsAttributeId: data[0],
                       Version: data[1]
                    };
                    if ( tokenNode ) {
                        conf.token = _tokenNode.get('title');
                    }
                    uploader = new eZAjaxUploader(win, conf, Y);
                    this.on('click', function (e) {
                        uploader.open();
                        e.halt();
                    });
                    this.removeClass('hide');
                });
            });
        });

    })();
    {/literal}
    </script>
    {/run-once}
{/if}
