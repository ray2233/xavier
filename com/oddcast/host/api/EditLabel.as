package com.oddcast.host.api
{

    public class EditLabel extends Object
    {
        public static var COLOR_SUFFIX:String = "_color";
        public static var HIGHLIGHT_SUFFIX:String = "_highlight";
        public static var F_SCENE_MAGNIFY:String = "Scene Magnify";
        public static var F_SCENE_DOLLY:String = "Scene Dolly";
        public static var F_GAMMA:String = "Scene Gamma";
        public static var F_FG_BASIS:String = "Scene FG basis";
        public static var F_EYES_IRIS_SIZE:String = "Eyes Iris Size";
        public static var F_EYES_IRIS_ASPECT:String = "Eyes Iris Aspect";
        public static var F_EYES_GAMMA:String = "Eyes Gamma";
        public static var F_EYES_PUPIL_SIZE:String = "Eyes Pupil Size";
        public static var F_EYES_REFLECTION:String = "Eyes Reflection";
        public static var F_EYE_VEINS_STRENGTH:String = "Eyes Veins Strength";
        public static var F_EYE_SHADE_STRENGTH:String = "Eyes Shade Strength";
        public static var F_EYES_REFLECTION_MOVE:String = "Eyes Dbg_Reflection Move";
        public static var F_EYES_MOUSEZ_MOVE:String = "Eyes MouseZ Move";
        public static var F_EYELASHES_OPACITY:String = "Eyes Lash Opacity";
        public static var F_EYELASHES_LENGTH:String = "Eyes Lash Trans";
        public static var F_EYELASHES_SCALE:String = "Eyes Lash Scale";
        public static var F_GLASSES_DARKNESS:String = "Glasses Lens Darkness";
        public static var F_GLASSES_REFLECTION:String = "Glasses Lens Reflection";
        public static var F_FULLPHOTO_SCALE:String = "Full Dbg_Photo Scale";
        public static var F_FULLPHOTO_TRANSLATE_X:String = "Full Dbg_Photo X";
        public static var F_FULLPHOTO_TRANSLATE_Z:String = "Full Dbg_Photo Z";
        public static var F_FULLPHOTO_FACE_MOVE_RANGE:String = "Full Dbg_Photo FaceMoveRange";
        public static var F_MOUTH_EXAGGERATION:String = "Mouth Exaggeration";
        public static var F_BEATS_MOVEMENT:String = "Beats Movement";
        public static var F_BEATS_DOLLY:String = "Beats Dolly";
        public static var F_BACKGROUND_REMOVAL_STRENGTH:String = "Background Removal Strength";
        public static var F_BACKGROUND_REMOVAL_SMOOTH:String = "Background Removal Smooth";
        public static var F_ANIMATED_WHOLE_ALPHA:String = "Animated Whole Alpha";
        public static var F_CONTROL_WHOLE_ALPHA:String = "Control Whole Alpha";
        public static var F_HAIR_MOMENTUM_WEIGHT:String = "Hair Weight";
        public static var F_HAIR_MOMENTUM_DAMPING:String = "Hair Damping";
        public static var F_HAIR_MOMENTUM_WIND_STRENGTH:String = "Hair Wind";
        public static var F_HAIR_MOMENTUM_WIND_NOISE:String = "Hair Wind Noise";
        public static var F_EYE_BRIGHTNESS:String = "eye brightness";
        public static var F_FACE_DETAIL:String = "Face Detail";
        public static var F_FACE_AGE:String = "Age";
        public static var F_FACE_GENDER:String = "Gender";
        public static var CI_ASYMM:String = "Asymmetry";
        public static var CI_CARICATURE:String = "Caricature";
        public static var F_FFT_POWER:String = "FreeFormTransform Power";
        public static var C_IRIS:String = "Eye RGB";
        public static var C_EYEWHITE:String = "EyeWhite GRAY";
        public static var C_MOUTH:String = "Mouth GRAY";
        public static var C_HAIR:String = "Hair RGB";
        public static var C_HAT:String = "Hat RGB";
        public static var C_COSTUME:String = "Costume RGB";
        public static var C_NECKLACE:String = "Necklace RGB";
        public static var C_GLASSES_FRAME:String = "Glasses Frame";
        public static var C_GLASSES_LENS:String = "Glasses Lens";
        public static var C_GLASSES_REFLECTION:String = "Glasses Reflection";
        public static var C_EYELASH:String = "Eyelash RGB";
        public static var U_FG:String = "Fg File";
        public static var U_HAIR:String = AccessoryTypeID.HAIR_3;
        public static var U_GLASSES:String = AccessoryTypeID.GLASSES_4;
        public static var U_COSTUME:String = AccessoryTypeID.COSTUME_6;
        public static var U_NECKLACE:String = AccessoryTypeID.NECKLACE_8;
        public static var U_HAT:String = AccessoryTypeID.HAT_9;
        public static var U_FACIALHAIR:String = AccessoryTypeID.FACIALHAIR_10;
        public static var U_BOTTOM:String = AccessoryTypeID.BOTTOM_13;
        public static var U_SHOES:String = AccessoryTypeID.SHOES_14;
        public static var U_PROPS:String = AccessoryTypeID.PROPS_15;
        public static var U_TORSO:String = AccessoryTypeID.TORSO_16;
        public static var U_EYESHADOW:String = AccessoryTypeID.EYESHADOW_17;
        public static var U_HEADPHONES:String = AccessoryTypeID.HEADPHONES_18;
        public static var U_LIP:String = AccessoryTypeID.LIP_19;
        public static var U_LEFTCHEEK:String = AccessoryTypeID.LEFTCHEEK_20;
        public static var U_RIGHTCHEEK:String = AccessoryTypeID.RIGHTCHEEK_21;
        public static var U_NOSERING:String = AccessoryTypeID.NOSERING_22;
        public static var U_LIPRING:String = AccessoryTypeID.LIPRING_23;
        public static var U_CHEEK:String = AccessoryTypeID.CHEEK_24;
        public static var U_BEAUTYSPOT:String = AccessoryTypeID.BEAUTYSPOT_25;
        public static var U_TATTOO:String = AccessoryTypeID.TATTOO_26;
        public static var U_STUBBLE:String = AccessoryTypeID.STUBBLE_27;
        public static var U_3D_NOSERING:String = AccessoryTypeID.NOSERING3D_28;
        public static var U_3D_FACIALHAIR:String = AccessoryTypeID.FACIALHAIR3D_29;
        public static var U_HEAD:String = AccessoryTypeID.HEAD_99;
        public static var U_XML:String = "xml";
        public static var U_CTL:String = "ctl";
        public static var B_UNDO:String = "Undo";
        public static var B_REDO:String = "Redo";
        public static var B_RESET:String = "Reset";
        public static var F_DEBUG_EYELASHEZ:String = "Debug LashZ";
        public static var F_DEBUG_HAIRZ:String = "Debug hairZ";
        public static var F_DEBUG_GLASSESZ:String = "Debug glassesZ";
        public static var F_DEBUG_VIDEOSTAR_VOLUME:String = "Volume VideoStar";
        public static var F_BLUR_FILTER:String = "Blur Filter";
        public static var F_BLUR_ASPECT:String = "Blur Aspect";
        public static var F_SCENE_SATURATION_FILTER:String = "Scene Saturation";
        public static var F_EYE_BLUR:String = "Eye_Blur";
        public static var F_RANDOM_HEAD_MOVEMENT_INTERVAL:String = "RandomHeadMovementInterval";
        public static var F_PAN_COMPENSATION:String = "PanCompensation";
        public static var F_TILT_COMPENSATION:String = "TiltCompensation";
        public static var F_PERMENANTHEADROTATIONX:String = "permenantHeadRotationX";
        public static var F_PERMENANTHEADROTATIONY:String = "permenantHeadRotationY";
        public static var F_PERMENANTHEADROTATIONZ:String = "permenantHeadRotationZ";
        public static var F_BREATH_DURATION:String = "breathDuration";
        public static var F_BREATH_AMPLITUDE:String = "breathAmplitude";
        public static var F_ADAMSAPPLE_AMPLITUDE:String = "adamsAppleAmplitude";
        public static var F_SPEECH_HEADMOVE_AMPLITUDE:String = "speechHeadMoveAmplitude";
        public static var F_BLEND_SHAPE_LIGHTING_LAYER_STRENGTH:String = "_blendShapeLightingLayerStrength";
        public static var F_MOUTH_BRIGHTNESS:String = "mouth brightness";
        public static var F_VISEME_ADVANCE:String = "visemeAdvance";

        public function EditLabel()
        {
            return;
        }// end function

    }
}
