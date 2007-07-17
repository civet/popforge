package de.popforge.widget.bitboy
{
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class BitMenu
	{
		private var player: BitboyPlayer;
		
		private var menu: ContextMenu;
		
		public function BitMenu( player: BitboyPlayer )
		{
			this.player = player;
			
			init();
		}
		
		private function init(): void
		{
			menu = new ContextMenu();
			menu.hideBuiltInItems();
			
			//-- create contextmenu
			var item: ContextMenuItem;
			
			item = new ContextMenuItem( 'credits ¬', false, false );
			menu.customItems.push( item );
			item = new ContextMenuItem( '- andré michelle [code]', false, false );
			menu.customItems.push( item );
			item = new ContextMenuItem( '- andre stubbe [design]', false, false );
			menu.customItems.push( item );
			item = new ContextMenuItem( '- joa ebert [code]', false, false );
			menu.customItems.push( item );

			item = new ContextMenuItem( 'Get 8bitboy!', true, true );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuSelect );
			menu.customItems.push( item );

			item = new ContextMenuItem( 'Mute Channel CTRL + [1-4]', true, false );
			menu.customItems.push( item );
			item = new ContextMenuItem( 'Keyboard Focus Required', false, false );
			menu.customItems.push( item );

			item = new ContextMenuItem( 'StereoEnhancer On', true, true );
			menu.customItems.push( item );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuSelect );

			item = new ContextMenuItem( 'BassBoost On', false, true );
			menu.customItems.push( item );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuSelect );
			
			player.contextMenu = menu;
		}
		
		private function onContextMenuSelect( event: ContextMenuEvent ): void
		{
			var item: ContextMenuItem = ContextMenuItem( event.target );
			
			switch( item.caption )
			{
				case 'Get 8bitboy!':
						
						navigateToURL( new URLRequest( 'http://8bitboy.popforge.de' ), '_top' );
						break;
					
				case 'StereoEnhancer On':
				
						item.caption = 'StereoEnhancer Off';
						player.setStereoEnhancement( true );
						break;

				case 'StereoEnhancer Off':
				
						item.caption = 'StereoEnhancer On';
						player.setStereoEnhancement( false );
						break;
					
				case 'BassBoost On':
				
						item.caption = 'BassBoost Off';
						player.setBassBoost( true );
						break;

				case 'BassBoost Off':
				
						item.caption = 'BassBoost On';
						player.setBassBoost( false );
						break;
			}
		}
	}
}