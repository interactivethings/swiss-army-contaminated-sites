/*global window,document,jQuery */

/*!
* Fitted: a jQuery Plugin
* @author: Trevor Morris (trovster)
* @modifiedBy: Richard Davies http://www.richarddavies.us
* @url: http://www.trovster.com/lab/code/plugins/jquery.fitted.js
* @documentation: http://www.trovster.com/lab/plugins/fitted/
* @published: 11/09/2008
* @updated: 26/02/2011
* @license Creative Commons Attribution Non-Commercial Share Alike 3.0 Licence
*		   http://creativecommons.org/licenses/by-nc-sa/3.0/
*
* @notes:
* Also see BigTarget by Leevi Graham - http://newism.com.au/blog/post/58/bigtarget-js-increasing-the-size-of-clickable-targets/
*
*/
if (typeof jQuery !== 'undefined') {
	jQuery(function ($) {
		$.fn.extend({
			fitted: function (options) {
				var settings = $.extend({}, $.fn.fitted.defaults, options),
					getSelectedText;

				getSelectedText = function () {
					if (window.getSelection) {
						return window.getSelection().toString();
					} else if (document.getSelection) {
						return document.getSelection();
					} else if (document.selection) {
						return document.selection.createRange().text;
					}
				};

				return this.each(function () {
					var $t	= $(this),
						o	= $.metadata ? $.extend({}, settings, $t.metadata()) : settings,
						$a,
						href,
						title;

					if ($t.find(':has(a)')) {
						$a		= $t.find('a:first');
						href	= $a.attr('href');
						title	= $a.attr('title');

						/**
						* Setup the Container
						* Add the 'container' class defined in settings
						* @event hover
						* @event click
						*/
						$t.addClass(o.className.container).hover(
							function (event) {
								var $$ = $(this);

								// Add the 'hover' class defined in settings
								$$.addClass(o.className.hover);

								// Add the Title Attribute if the option is set, and it's not empty
								if (typeof o.title !== 'undefined' && o.title === true && title !== '') {
									$$.attr('title', title);
								}

								// Set the Status bar string if the option is set
								if (typeof o.status !== 'undefined' && o.status === true) {
									if ($.browser.safari) {
										// Safari Formatted Status bar string
										window.status = 'Go to "' + href + '"';
									} else {
										// Default Formatted Status bar string
										window.status = href;
									}
								}
							},
							function (event) {
								var $$ = $(this);

								// Remove the Title Attribute if it was set by the Plugin
								if (typeof o.title !== 'undefined' && o.title === true && title !== '') {
									$$.removeAttr('title');
								}

								// Remove the 'hover' class defined in settings
								$$.removeClass(o.className.hover);

								// Remove the Status bar string
								window.status = '';
							}
						).bind('click.fitted', function (event) {
							// Don't do anything if selecting text inside fitted element
							if (getSelectedText().length > 0) {
								return true;
							}

							// Don't override clicks on form elements
							if ($(event.target).is('input, select, option, optgroup textarea, button')) {
								return true;
							}

							if ($(event.target).closest('a').length) {
								$a		= $(event.target).closest('a');
								href	= $a.attr('href');
							}

							// Trigger the Anchor / Follow the Link
							if ($a.is('[rel*=external]')) {
								window.open(href);
								event.preventDefault();
							} else {
								window.location = href;
							}
						});
					}
				});
			}
		});
		
		$.fn.fitted.defaults = {
			title:	true,
			status:	false,
			className: {
				'container':	'fitted',
				'hover':		'hovered'
			}
		};
		
	}(jQuery));
}