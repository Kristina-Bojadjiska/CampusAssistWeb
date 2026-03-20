/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author kchip
 */

package com.campusassist.campusassistweb.helpers;

import java.util.ArrayList;
import java.util.List;

public class SessionHelper {
    public static List<String> filterAcademicSessions(List<String> sessions) {
        List<String> result = new ArrayList<>();
        for (String session : sessions) {
            if (session.toLowerCase().contains("academic")) {
                result.add(session);
            }
        }
        return result;
    }
}
