Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5F021A725
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 20:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGIShg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGIShg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 14:37:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384EBC08C5CE
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jul 2020 11:37:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z7so3912035ybz.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jul 2020 11:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jX3Dl5MD86mdHXIoT9uhkh4rwhA/qfoAVP4P5zty3kA=;
        b=WgEsD0UEzsJV03enG5aRoI3j2aW3S9lLqUsDOuWaj4TZga8a4G9C3ZYMk2ZgY7xzLg
         G2MrbeOBrB9vhTy92N4KyJn7e9e5Nj+p2Xi0vH5IZGNkSCG8eQIC15yljwa3qJ58661z
         dBVQ4RBz4NNO7Q7Z/Hwy7u8CEBkNvhGz/7UEq++bMx1gNtNkfeFQEL9Os+rbQ3Z2CM3p
         62MT39WSuxfx2B1zGTa4dK8toluusmAHqjdXjq4XPY2YbWLRX0jlqRn8Zjq7Wxr9suh9
         40Dyx8vcy+facuoqlJGacyO6WW8kqNzLD6ZdNsXSlZsQybT8xPmwjM6ix3a2vjaXT1Jw
         jrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jX3Dl5MD86mdHXIoT9uhkh4rwhA/qfoAVP4P5zty3kA=;
        b=SGOHUpwnjc5SXtHTXHMnfF0FoCDDCIt+KPrUAxb4Gis4h004pr7Q5UgmlhUkZnqZRl
         RCDXyYTuuMDcbDYAAVvFqW3Vo36pRLPftCBlXL/45SApEkcqG3guG92bw5b6opKAS95J
         yfLAzIGuY109Cwzn6L0GXqua8L5zIBRvZxxKV99U3gWNgfaCqSK6JsuiV1iCdD20t54x
         K1W0bEoFMI0aOX4pJ4J4GutGe4KRyqIRbrS/unpU/sqLvm6RcvZeubGW/8uP968QiPJs
         JKzSZRXPsJfBVOk7LngrXyOzU+ELcFtXG/1ZhjuVc/XyBDZExHzJc99S6mTfcWKBJ1bS
         HZ4A==
X-Gm-Message-State: AOAM533Qrjdit8hm9VCnLSyYfoKp5CwscBSvlO1ZI+q+txskhrYk8cqs
        FsWaNeEITZ5XuU8UDFsSURVCtPqnymg=
X-Google-Smtp-Source: ABdhPJwHvBa/Xhxv6BP99lYbeqO814swZ9afJP0a3xYjlceyai+zBMgK4+f/oQEsWkzp73BD/2ySbzyOj+M=
X-Received: by 2002:a25:d046:: with SMTP id h67mr12549102ybg.458.1594319855427;
 Thu, 09 Jul 2020 11:37:35 -0700 (PDT)
Date:   Thu,  9 Jul 2020 18:37:01 +0000
Message-Id: <20200709183701.2564213-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [xfstests-bld PATCH] test-appliance: exclude generic/587 from the
 encrypt tests
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
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
 1 file changed, 1 insertion(+)

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
-- 
2.27.0.383.g050319c2ae-goog

