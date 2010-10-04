package externalsounds_fla 
{
    import com.hydrotik.utils.*;
    import flash.display.*;
    
    public dynamic class MainTimeline extends flash.display.MovieClip
    {
        public function MainTimeline()
        {
            super();
            addFrameScript(0, frame1);
            return;
        }

        internal function frame1():*
        {
            SoundManager.getInstance().addItem(new Loop1());
            SoundManager.getInstance().addItem(new Loop2());
            SoundManager.getInstance().addItem(new Loop3());
            SoundManager.getInstance().addItem(new Loop4());
            return;
        }
    }
}
