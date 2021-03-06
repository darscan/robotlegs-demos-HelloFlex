//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.demos.hello.config
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	import mx.core.IVisualElementContainer;
	import robotlegs.bender.demos.hello.controller.SayHelloCommand;
	import robotlegs.bender.demos.hello.views.IMessageWriter;
	import robotlegs.bender.demos.hello.views.MessageWriterMediator;
	import robotlegs.bender.demos.hello.views.MessageWriterView;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;

	public class AppConfig implements IConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var context:IContext;

		[Inject]
		public var eventCommandMap:IEventCommandMap;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var dispatcher:IEventDispatcher;

		[Inject]
		public var contextView:ContextView;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configure():void
		{
			context.logLevel = LogLevel.DEBUG;

			eventCommandMap
				.map(Event.INIT)
				.toCommand(SayHelloCommand);

			mediatorMap
				.map(IMessageWriter)
				.toMediator(MessageWriterMediator);

			context.afterInitializing(init);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function init():void
		{
			// add the view that has the mediator mapped to it
			IVisualElementContainer(contextView.view)
				.addElement(new MessageWriterView());

			// dispatch the event that is bound to the command
			// send on the next frame (mediator won't be ready this frame)
			setTimeout(function():void {
				dispatcher.dispatchEvent(new Event(Event.INIT));
			}, 1);
		}
	}
}
