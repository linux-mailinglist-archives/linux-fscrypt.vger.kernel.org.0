Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECCB158658
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBKAAu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:00:50 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38794 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKAAu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:00:50 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so4509823pfc.5
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUF2HLL14kZytMn37pkAatXRP35mL6xpENUEHb3f2cA=;
        b=X90c4z98XfN2rd/D+R0+qcbXgVmtGSQBZbP80PEK4W3G7oOy/7UR83qKUvYgHGDZ92
         OIlJ2zZ45EBBpC9FxOmA3v6vxpRFUgAqFrEgt0xfCPoNl2ZL9Rgw3FaSS0gk3pQoZ/VE
         yy5mZn4wgbHJtZ9F6HK+x8mqcOZitQtiT97j8OjSakaYozqu7ysA5W28NbuTfDTTNTNr
         OJ+Z/1tUbvbuciJlgPlOHiXQmyae8t9FJtAhEsxoX7diV+yo+Ne2Ob5ZVBg8F1yvNN9L
         VcTdoRjisgdsvyK3CyaSiwDcUvu5ymrEHfa5tHvJ3lciUmpSzDpvjrtIxsJrRy4RGkk+
         hD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUF2HLL14kZytMn37pkAatXRP35mL6xpENUEHb3f2cA=;
        b=i9a9nTJ70saq4/SGSEspYZgvR1uGjNxe+0wAgK3D09//VBfLK7uywc+cfXtx+FoDnO
         HMBoNdlW1D5fvxXCUuRzESgXllZq13mRNGf0d5S1SqO3Gud29c2ZRGFibv9XRMKyJH/T
         48h5tgN6qQn6/7A+eJjWHpSXWO/h+3XiHMDftD07slMqBy8X05k1DVympRe+8QT9bgEI
         JoHSDeua/i2aCtWZYTwNDMM5pNZbrZBdjnGNdpK4Yn7iVDMNzbGS+K5vgQ7GrFSwlS9F
         oEscZtxmzgUZ3eUA6YSOOOfu5t9ZuVDrKkFSryu9yVTLhr7ibMd2nvYL2DodAhNA323B
         +sTA==
X-Gm-Message-State: APjAAAVyDkCUzIF/o9I2tIDNfzNGKZrefW5dWUYflabHcyOPmQBKIWiJ
        gXugM1gA/ixC8QMB4Y76N/TbseOxsmU=
X-Google-Smtp-Source: APXvYqwOl0F6qrNk10qIU7kZCWqei9cwZibdv3/+5AaomSXBYp/0LsUUSFb8Mt4HprydmJmGgsliOg==
X-Received: by 2002:a65:43cb:: with SMTP id n11mr4003621pgp.65.1581379249489;
        Mon, 10 Feb 2020 16:00:49 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id q187sm1435510pfq.185.2020.02.10.16.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:00:48 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/7] Build basic shared library
Date:   Mon, 10 Feb 2020 19:00:31 -0500
Message-Id: <20200211000037.189180-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index b9c09b9..006fc60 100644
--- a/Makefile
+++ b/Makefile
@@ -1,20 +1,32 @@
 EXE := fsverity
+LIB := libfsverity.so
 CFLAGS := -O2 -Wall
 CPPFLAGS := -D_FILE_OFFSET_BITS=64
 LDLIBS := -lcrypto
 DESTDIR := /usr/local
+LIBDIR := /usr/lib64
 SRC := $(wildcard *.c)
-OBJ := $(SRC:.c=.o)
+OBJ := fsverity.o
+SSRC := hash_algs.c cmd_sign.c cmd_enable.c cmd_measure.c util.c
+SOBJ := hash_algs.so cmd_sign.so cmd_enable.so cmd_measure.so util.so
 HDRS := $(wildcard *.h)
 
 all:$(EXE)
 
-$(EXE):$(OBJ)
+$(EXE):$(OBJ) $(LIB)
+	$(CC) -o $@ $< -L . -l fsverity
 
 $(OBJ): %.o: %.c $(HDRS)
+	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
+
+$(SOBJ): %.so: %.c $(HDRS)
+	$(CC) -c -fPIC $(CFLAGS) $(CPPFLAGS) $< -o $@
+
+libfsverity.so: $(SOBJ)
+	$(CC) $(LDLIBS) -shared -o libfsverity.so $(SOBJ)
 
 clean:
-	rm -f $(EXE) $(OBJ)
+	rm -f $(EXE) $(OBJ) $(SOBJ) $(LIB)
 
 install:all
 	install -Dm755 -t $(DESTDIR)/bin $(EXE)
-- 
2.24.1

