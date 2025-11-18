// Presented by: CV. Irando
// www.irando.co.id
(function (factory) {
    /* global define */
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node/CommonJS
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals: jQuery
        factory(window.jQuery);
    }
}(function ($) {
    // Extends plugins for adding highlight.
    //  - plugin is external module for customizing.
    $.extend($.summernote.plugins, {
        /**
         * @param {Object} context - context object has status of editor.
         */
        'highlight': function (context) {
            var self = this;

            var ui = $.summernote.ui;
            var $editor = context.layoutInfo.editor;
            var options = context.options;
            var lang = options.langInfo;


            // add button

            context.memo('button.highlight', function () {
                // create button
                var button = ui.button({
                    contents: '<i class="fas fa-file-code"></i>',
                    tooltip: 'highlight',
                    click: function () {
                        self.show()
                    }
                });

                // create jQuery object from button instance.
                var $highlight = button.render();
                return $highlight;
            });

            this.createDialog = function () {
                var $box = $('<div />');
                var $selectGroup = $('<div class="form-group" />');
                var $textGroup = $('<div class="form-group" />');
                var $select = $('<select class="form-control ext-highlight-select" />');

                // all supported langs by prism https://prismjs.com/#supported-languages
                var languages = [
                    'delphi',
                    'pascal',
                    'sql',
                    'markup',
                    'html',
                    'xml',
                    'svg',
                    'mathml',
                    'css',
                    'clike',
                    'javascript',
                    'abap',
                    'abnf',
                    'actionscript',
                    'ada',
                    'antlr4',
                    'apacheconf',
                    'apl',
                    'applescript',
                    'aql',
                    'arduino',
                    'arff',
                    'asciidoc',
                    'asm6502',
                    'aspnet',
                    'autohotkey',
                    'autoit',
                    'bash',
                    'shell',
                    'basic',
                    'basic',
                    'bbcode',
                    'bison',
                    'bnf',
                    'brainfuck',
                    'brightscript',
                    'bro',
                    'c',
                    'concurnas',
                    'csharp',
                    'cpp',
                    'cil',
                    'coffeescript',
                    'coffee',
                    'cmake',
                    'clojure',
                    'crystal',
                    'csp',
                    'css-extras',
                    'd',
                    'dart',
                    'diff',
                    'django',
                    'dns-zone',
                    'docker',
                    'ebnf',
                    'eiffel',
                    'ejs',
                    'elixir',
                    'elm',
                    'etlua',
                    'erb',
                    'erlang',
                    'fsharp',
                    'factor',
                    'firestore-security-rules',
                    'flow',
                    'fortran',
                    'ftl',
                    'gcode',
                    'gdscript',
                    'gedcom',
                    'gherkin',
                    'git',
                    'glsl',
                    'gml',
                    'gamemakerlanguage',
                    'go',
                    'graphql',
                    'groovy',
                    'haml',
                    'handlebars',
                    'haskell',
                    'hs',
                    'haxe',
                    'hcl',
                    'http',
                    'hpkp',
                    'hsts',
                    'ichigojam',
                    'icon',
                    'inform7',
                    'ini',
                    'io',
                    'j',
                    'java',
                    'javadoc',
                    'javadoclike',
                    'javadoclike',
                    'jolie',
                    'jq',
                    'jsdoc',
                    'js-extras',
                    'js-templates',
                    'json',
                    'jsonp',
                    'json5',
                    'julia',
                    'keyman',
                    'kotlin',
                    'latex',
                    'latte',
                    'less',
                    'lilypond',
                    'liquid',
                    'lisp',
                    'livescript',
                    'lolcode',
                    'lua',
                    'makefile',
                    'markdown',
                    'markup-templating',
                    'matlab',
                    'mel',
                    'mizar',
                    'monkey',
                    'moonscript',
                    'n1ql',
                    'n4js',
                    'nand2tetris-hdl',
                    'nasm',
                    'neon',
                    'nginx',
                    'nim',
                    'nix',
                    'nsis',
                    'objectivec',
                    'ocaml',
                    'opencl',
                    'oz',
                    'parigp',
                    'parser',
                    'pascaligo',
                    'pcaxis',
                    'perl',
                    'php',
                    'phpdoc',
                    'php-extras',
                    'plsql',
                    'powershell',
                    'processing',
                    'prolog',
                    'properties',
                    'protobuf',
                    'pug',
                    'puppet',
                    'pure',
                    'python',
                    'q',
                    'qml',
                    'qore',
                    'r',
                    'jsx',
                    'tsx',
                    'renpy',
                    'reason',
                    'regex',
                    'rest',
                    'rip',
                    'roboconf',
                    'robotframework',
                    'ruby',
                    'rust',
                    'sas',
                    'sass',
                    'scss',
                    'scala',
                    'scheme',
                    'shell-session',
                    'smalltalk',
                    'smarty',
                    'solidity',
                    'soy',
                    'sparql',
                    'splunk-spl',
                    'sqf',
                    'stylus',
                    'swift',
                    'tap',
                    'tcl',
                    'textile',
                    'toml',
                    'tt2',
                    'turtle',
                    'twig',
                    'typescript',
                    't4',
                    't4-vb',
                    't4-templating',
                    'vala',
                    'vbnet',
                    'velocity',
                    'verilog',
                    'vhdl',
                    'vim',
                    'visual-basic',
                    'wasm',
                    'wiki',
                    'xeora',
                    'xojo',
                    'xquery',
                    'yaml',
                    'zig'
                ];

                for (var i = 0; i < languages.length; i++) {
                    $select.append('<option value="' + languages[i] + '">' + languages[i] + '</option>');
                }

                var $label = $('<label />');
                $label.html('Select language');
                $box.append($selectGroup.append($label));
                $box.append($selectGroup.append($select));

                var $label = $('<label />');
                $label.html('Enter the code fragment');
                var $textarea = $('<textarea class="ext-highlight-code form-control" rows="10" />');

                $box.append($textGroup.append($label));
                $box.append($textGroup.append($textarea));

                return $box.html();
            };

            this.createCodeNode = function (code, select) {
                var $code = $('<code>');
                $code.html(code.replace(/</g,"&lt;").replace(/>/g,"&gt;"));
                $code.addClass('language-' + select);

                var $pre = $('<pre>');
                $pre.html($code)
                $pre.addClass('language-' + select);

                return $pre[0];
            };

            this.showHighlightDialog = function (codeInfo) {
                return $.Deferred(function (deferred) {
                    var $extHighlightCode = self.$dialog.find('.ext-highlight-code');
                    var $extHighlightBtn = self.$dialog.find('.ext-highlight-btn');
                    var $extHighlightSelect = self.$dialog.find('.ext-highlight-select');

                    ui.onDialogShown(self.$dialog, function () {
                        context.triggerEvent('dialog.shown');

                        $extHighlightCode.val(codeInfo);

                        $extHighlightCode.on('input', function () {
                            ui.toggleBtn($extHighlightBtn, $extHighlightCode.val() != '');

                            codeInfo = $extHighlightCode.val();
                        });

                        $extHighlightBtn.one('click', function (event) {
                            event.preventDefault();
                            
                            context.invoke('editor.restoreRange');

                            context.invoke('editor.pasteHTML', '<br>');

                            context.invoke('editor.restoreRange');                            

                            context.invoke('editor.insertNode', self.createCodeNode(codeInfo, $extHighlightSelect.val()));

                         
                            self.$dialog.modal('hide');

                            hljs.highlightAll();                                              
                        });
                    });

                    ui.onDialogHidden(self.$dialog, function () {
                        context.triggerEvent('dialog.shown');
                        deferred.resolve();
                    });
                    ui.showDialog(self.$dialog);
                }).promise();
            };

            this.getCodeInfo = function () {
                var text = context.invoke('editor.getSelectedText');
                return '';
            };

            this.show = function () {
                var codeInfo = self.getCodeInfo();

                context.invoke('editor.saveRange');
                this.showHighlightDialog(codeInfo).then(function (codeInfo) {
                    // context.invoke('editor.restoreRange');
                });
            };

            //// This events will be attached when editor is initialized.
            //this.event = {
            //    // This will be called after modules are initialized.
            //    'summernote.init': function (we, e) {
            //        console.log('summernote initialized', we, e);
            //    },
            //    // This will be called when user releases a key on editable.
            //    'summernote.keyup': function (we, e) {
            //        console.log('summernote keyup', we, e);
            //    }
            //};
            //
            //// This method will be called when editor is initialized by $('..').summernote();
            //// You can create elements for plugin
            this.initialize = function () {
                var $container = options.dialogsInBody ? $(document.body) : $editor;

                var body = [
                    '<button href="#" class="btn btn-primary ext-highlight-btn disabled" disabled>',
                    'Insert code',
                    '</button>'
                ].join('');

                this.$dialog = ui.dialog({
                    className: 'ext-highlight',
                    title: 'Insert code',
                    body: this.createDialog(),
                    footer: body,
                    //callback: function ($node) {
                    //    $node.find('.modal-body').css({
                    //        'max-height': 300,
                    //        'overflow': 'scroll'
                    //    });
                    //}
                }).render().appendTo($container);
            };

            // This methods will be called when editor is destroyed by $('..').summernote('destroy');
            // You should remove elements on `initialize`.
            this.destroy = function () {
                ui.hideDialog(this.$dialog);
                this.$dialog.remove();
            };
        }
    });
}));
