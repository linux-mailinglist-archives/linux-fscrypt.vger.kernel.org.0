Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D518296454
	for <lists+linux-fscrypt@lfdr.de>; Thu, 22 Oct 2020 20:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504374AbgJVSAC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Oct 2020 14:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369478AbgJVR76 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Oct 2020 13:59:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8699C0613CE
        for <linux-fscrypt@vger.kernel.org>; Thu, 22 Oct 2020 10:59:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x7so3674284wrl.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 22 Oct 2020 10:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3COIAKMiRaCZvU+z1UGm0wDOnatxAwrbULuU6Uy5+Eo=;
        b=hbQy9OdqPNMPCNUWc3zSFS8O6eV7cqfBkCi8lkwQ5nRDdZL/3lS6ajblswKPSFHFjT
         c61J91z6MsZ8pf4Unscw6nL1s8o3+CgTqsYfFGSfYDNbDIu0pEwuGfz0seqZOlKEFxzY
         8GAXwGW5FBc518AgkSrDjrluBW0pY1YUTOTn+O/KjYuH1GGOquniln+1aexyj2/SpFXt
         dkRPNy8XYdDOmWFRMkvgY+CQQ5klYfBCYb0oA9yPuziuHad1RZIRVWtmwpFbEUuE7ojY
         vTZjhHclJx47ikOChcwqOYHe54nPIjF47eB6mRIb9gRLkDLVv8ewDGNRqL88e/VHrBRP
         3LNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3COIAKMiRaCZvU+z1UGm0wDOnatxAwrbULuU6Uy5+Eo=;
        b=rJcuii5IAAqAaDCxyIw4jaRW/irgQmRnEz92AJIAlHStVhagwr6NdYACf9vewhoAq/
         yifiWsDZpKi17Nd2oUAtt5E0EkPVwEXUUcj+2eCxHvFXgOTGEEf/2rlie8JkrKcb35sp
         CaUYNBBaweNWoCX2FmFdeMLNdGbEBkYXxi6xe9ERE3/oCeFpoJ1LWxmpZ4Yayib9HFOm
         QOrfVYgtlBDb/wpXFkIF67jc7CB/x+IZTu7C8vRGyWgXP94KsLr81JALCrfN2QyFtxU/
         Lr0lxF1qjuFOV2AFp9ir/7eQv+mRnc1KnsFlCtXoGIMzZzQKTJE2KcH/iFMaMZrvaSba
         7jCA==
X-Gm-Message-State: AOAM531nWjoI/qF0gazxc4nGrFGqrz41I7t5h/kFybUpaTOPd4Fd79AP
        Tiew/agqUndDHHDUZiBATU4yaikjRDoNpw==
X-Google-Smtp-Source: ABdhPJzEi6Hqu3h0HoxGCNP73fFwdAeHFtbqr6Fj4HqV+kNFRugrQn/hicvWuSw3MpP8N1Lt52tAmw==
X-Received: by 2002:adf:e8c7:: with SMTP id k7mr3989755wrn.102.1603389595041;
        Thu, 22 Oct 2020 10:59:55 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id x81sm4902822wmb.11.2020.10.22.10.59.54
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 10:59:54 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH 2/2] Generate and install libfsverity.pc
Date:   Thu, 22 Oct 2020 18:59:34 +0100
Message-Id: <20201022175934.2999543-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022175934.2999543-1-luca.boccassi@gmail.com>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

pkg-config is commonly used by libraries to convey information about
compiler flags and dependencies.
As packagers, we heavily rely on it so that all our tools do the right
thing by default regardless of the environment.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
 Makefile              | 13 ++++++++++++-
 lib/libfsverity.pc.in | 10 ++++++++++
 scripts/do-release.sh |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)
 create mode 100644 lib/libfsverity.pc.in

diff --git a/Makefile b/Makefile
index 122c0a2..07b828f 100644
--- a/Makefile
+++ b/Makefile
@@ -119,6 +119,15 @@ libfsverity.so:libfsverity.so.$(SOVERSION)
 
 DEFAULT_TARGETS += libfsverity.so
 
+# Create the pkg-config file
+libfsverity.pc:
+	sed -e "s|@PREFIX@|$(PREFIX)|" \
+		-e "s|@LIBDIR@|$(LIBDIR)|" \
+		-e "s|@INCDIR@|$(INCDIR)|" \
+		lib/libfsverity.pc.in > $@
+
+DEFAULT_TARGETS += libfsverity.pc
+
 ##############################################################################
 
 #### Programs
@@ -190,11 +199,12 @@ check:fsverity test_programs
 	@echo "All tests passed!"
 
 install:all
-	install -d $(DESTDIR)$(LIBDIR) $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
+	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
 	install -m755 fsverity $(DESTDIR)$(BINDIR)
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
+	install -m644 libfsverity.pc $(DESTDIR)$(LIBDIR)/pkgconfig
 	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
 
 uninstall:
@@ -202,6 +212,7 @@ uninstall:
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
+	rm -f $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 	rm -f $(DESTDIR)$(INCDIR)/libfsverity.h
 
 help:
diff --git a/lib/libfsverity.pc.in b/lib/libfsverity.pc.in
new file mode 100644
index 0000000..613e9bc
--- /dev/null
+++ b/lib/libfsverity.pc.in
@@ -0,0 +1,10 @@
+prefix=@PREFIX@
+libdir=@LIBDIR@
+includedir=@INCDIR@
+
+Name: libfsverity
+Description: fs-verity library
+Version: 1.2
+Libs: -L${libdir} -lfsverity
+Requires.private: libcrypto
+Cflags: -I${includedir}
diff --git a/scripts/do-release.sh b/scripts/do-release.sh
index 255fc53..352fcf1 100755
--- a/scripts/do-release.sh
+++ b/scripts/do-release.sh
@@ -28,6 +28,8 @@ minor=$(echo "$VERS" | cut -d. -f2)
 sed -E -i -e "/FSVERITY_UTILS_MAJOR_VERSION/s/[0-9]+/$major/" \
 	  -e "/FSVERITY_UTILS_MINOR_VERSION/s/[0-9]+/$minor/" \
 	  include/libfsverity.h
+sed -E -i "/Version:/s/[0-9]+\.[0-9]+/$VERS/" \
+	  lib/libfsverity.pc.in
 git commit -a --signoff --message="v$VERS"
 git tag --sign "v$VERS" --message="$PKG"
 
-- 
2.20.1

