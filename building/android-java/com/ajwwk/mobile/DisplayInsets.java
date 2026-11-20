package com.ajwwk.mobile;

import android.app.Activity;
import android.graphics.Insets;
import android.os.Build;
import android.view.DisplayCutout;
import android.view.RoundedCorner;
import android.view.View;
import android.view.WindowInsets;
import org.haxe.extension.Extension;

public final class DisplayInsets {
    private static volatile View watchedView;
    private static volatile int[] currentInsets;

    private DisplayInsets() {}

    // JNI reads an immutable snapshot. View access stays on the Android UI thread.
    public static int[] getInsets() {
        if (Build.VERSION.SDK_INT < 28) return null;

        Activity activity = Extension.mainActivity;
        View content = Extension.mainView;
        if (activity == null || content == null) return null;
        if (watchedView != content) {
            activity.runOnUiThread(() -> watch(activity.getWindow().getDecorView(), content));
            return null;
        }
        return currentInsets;
    }

    private static void watch(View decor, View content) {
        if (watchedView == content) return;
        currentInsets = null;
        watchedView = content;
        content.setOnApplyWindowInsetsListener((view, insets) -> {
            updateInsets(decor, view, insets);
            return view.onApplyWindowInsets(insets);
        });
        content.addOnLayoutChangeListener((view, left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom) ->
            updateInsets(decor, view, null));
        updateInsets(decor, content, null);
        content.requestApplyInsets();
    }

    private static void updateInsets(View decor, View content, WindowInsets dispatchedInsets) {
        if (content != watchedView) return;
        WindowInsets insets = decor.getRootWindowInsets();
        if (insets == null) insets = dispatchedInsets;
        if (insets == null || content.getWidth() <= 0 || content.getHeight() <= 0) return;

        int left = 0;
        int top = 0;
        int right = 0;
        int bottom = 0;
        DisplayCutout cutout = insets.getDisplayCutout();
        if (cutout != null) {
            left = cutout.getSafeInsetLeft();
            top = cutout.getSafeInsetTop();
            right = cutout.getSafeInsetRight();
            bottom = cutout.getSafeInsetBottom();
            if (Build.VERSION.SDK_INT >= 30) {
                Insets waterfall = cutout.getWaterfallInsets();
                left = Math.max(left, waterfall.left);
                top = Math.max(top, waterfall.top);
                right = Math.max(right, waterfall.right);
                bottom = Math.max(bottom, waterfall.bottom);
            }
        }
        if (Build.VERSION.SDK_INT >= 31) {
            int topLeft = cornerInset(insets, RoundedCorner.POSITION_TOP_LEFT);
            int topRight = cornerInset(insets, RoundedCorner.POSITION_TOP_RIGHT);
            int bottomLeft = cornerInset(insets, RoundedCorner.POSITION_BOTTOM_LEFT);
            int bottomRight = cornerInset(insets, RoundedCorner.POSITION_BOTTOM_RIGHT);
            left = Math.max(left, Math.max(topLeft, bottomLeft));
            top = Math.max(top, Math.max(topLeft, topRight));
            right = Math.max(right, Math.max(topRight, bottomRight));
            bottom = Math.max(bottom, Math.max(bottomLeft, bottomRight));
        }

        int[] decorOrigin = new int[2];
        int[] contentOrigin = new int[2];
        decor.getLocationInWindow(decorOrigin);
        content.getLocationInWindow(contentOrigin);
        int x = contentOrigin[0] - decorOrigin[0];
        int y = contentOrigin[1] - decorOrigin[1];
        int width = content.getWidth();
        int height = content.getHeight();
        currentInsets = new int[] {
            Math.max(0, left - x),
            Math.max(0, top - y),
            Math.max(0, x + width - (decor.getWidth() - right)),
            Math.max(0, y + height - (decor.getHeight() - bottom)),
            width,
            height
        };
    }

    private static int cornerInset(WindowInsets insets, int position) {
        RoundedCorner corner = insets.getRoundedCorner(position);
        // The rectangular safe area meets the corner arc along its 45-degree diagonal.
        return corner == null ? 0 : (int) Math.ceil(corner.getRadius() * (1 - 1 / Math.sqrt(2)));
    }
}
