Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B44821A763
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 20:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGIS6w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 14:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIS6w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 14:58:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E726C08C5CE
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jul 2020 11:58:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f4so1814465plo.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jul 2020 11:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZHLmoCV6SaQCm/f+hfcq4pNwidGURq5pT+7611o3P3g=;
        b=MJ/RFZrhMUofKT6yP3tXFe/APvhHyd/CvVsPbyqrXy7ueSEs83FeizJoyWui54k6PX
         dPX8sBCNQTqGhrZrtBWZRkzx8A4Yng/pc8kcizqjkNgbiVmeNmAcXdeMJ1jBoaWeabuE
         s8nsXu9CyGFNQGjwntKXD3mfHLJjxa6xhJG64s4lnkd0oiQ0Ti7IDqVK6+WNAVvnsQHU
         fDnrYfsQ8nxWhQP9yJKGG95/JUvbkQML7xz89gpT3cEbRA2Frt1qx+1JDQRS9xiD0zJL
         pui1rK1yzZZKiLmy7JtnuNBBz3PGg39CoObLMmp01h6aarEH0hgeG6CkkpxE32AWNsxL
         fJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZHLmoCV6SaQCm/f+hfcq4pNwidGURq5pT+7611o3P3g=;
        b=LSCNmU+lEQSzqjzEPzR2zQnJAMIAf51e8BcA5xKDeY4a1+ugAGesZr7WC5jIudJl94
         viKBop/pxETUi6xE20vacBjHO3v8JnCw4lzCSkn1HMqV7uF7Ygtk7kygXPtS/6gZwomS
         d+DN75PvYsVuECD+9sIKLZbKPTBgIy+GsjUkSIYWzHtjy0X/uLcX83XqwldCkWrN5VOa
         hYBfng7FhqsDLdKreSWxuyXcZi3ZEsunNsehvOSD9Q8k+BY1Qgs13IT4NweyyigN4M6g
         jfRzXNmq+6L64MUCB9E7EIq290qA0ySL9ACXN1Z+UUBDdOrPogqdcy/pCGIm1nW2OhWv
         yFnQ==
X-Gm-Message-State: AOAM530OACU5pc2Wo4FTVtq9Bo6xwMRlNG1qs+Z2Y3CTBL+7YSQZ3wMA
        X8EP/QTUTncum5bYSFiMNUL3hHZh+aQ=
X-Google-Smtp-Source: ABdhPJzp5b1L6CnXgJnEnpTIsuWtJdtvMFJC2bpQFbi1AFTeDJyCvvMTGlbPPX16XC5BVEbCr3r0tLqjgb8=
X-Received: by 2002:a17:90b:4c12:: with SMTP id na18mr746631pjb.0.1594321131852;
 Thu, 09 Jul 2020 11:58:51 -0700 (PDT)
Date:   Thu,  9 Jul 2020 18:58:32 +0000
In-Reply-To: <20200709184145.GA3855682@gmail.com>
Message-Id: <20200709185832.2568081-1-satyat@google.com>
Mime-Version: 1.0
References: <20200709184145.GA3855682@gmail.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [xfstests-bld PATCH v2] test-appliance: exclude generic/587 from the
 encrypt tests
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>, ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The encryption feature doesn't play well with quota, and generic/587
tests quota functionality.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 .../test-appliance/files/root/fs/ext4/cfg/encrypt.exclude        | 1 +
 .../test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
index 47c26e7..07111c2 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
@@ -24,6 +24,7 @@ generic/270
 generic/381
 generic/382
 generic/566
+generic/587
 
 # encryption doesn't play well with casefold (at least not yet)
 generic/556
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
index cd60151..1f5a7e5 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
@@ -20,6 +20,7 @@ generic/235
 generic/270
 generic/382
 generic/204
+generic/587
 
 # These tests are also excluded in 1k.exclude.
 # See there for the reasons.
-- 
2.27.0.383.g050319c2ae-goog

