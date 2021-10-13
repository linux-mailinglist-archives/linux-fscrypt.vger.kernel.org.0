Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4963142C993
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhJMTJN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:13 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49066 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id D3D7520B9D01;
        Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D3D7520B9D01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634151999;
        bh=yIxQ/i84K/WAWPXS3Zi8wDxbgHtCOMqXXBG94r/Of8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6wGOGS+Ey7bkWdMeWCjxzJKMzzFdZXH+M3f46+W4anu6w4EJhH+EO2ui6Rz0NFXm
         GFlg8s5fkqvAQf8aBR8XlKYr7HnPNTtQvsScPHpRgMK4Z/Oh+Y2Osa4Wdg3q193Pad
         1XSkidWOiJ6s/wIqg7jgpyLrymzluhi+AvQOTCzU=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 06/16] uapi|audit: add trust audit message definitions
Date:   Wed, 13 Oct 2021 12:06:25 -0700
Message-Id: <1634151995-16266-7-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

Introduce new definitions to audit.h centered around trust
decisions and policy loading and activation, as an extension
of the mandatory access control fields.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Change audit records to MAC region (14XX) from
    Integrity region (18XX), as IPE is an effectively a MAC system
    around trust versus an extension to the integrity subsystem.
  * Generalize the #defines to support the class of trust-based
    Access-Control LSMs.

---
 include/uapi/linux/audit.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index daa481729e9b..3a83b3605896 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -139,6 +139,10 @@
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
 #define AUDIT_MAC_CALIPSO_ADD	1418	/* NetLabel: add CALIPSO DOI entry */
 #define AUDIT_MAC_CALIPSO_DEL	1419	/* NetLabel: del CALIPSO DOI entry */
+#define AUDIT_TRUST_RESULT	1420	/* IPE Denial or Grant */
+#define AUDIT_TRUST_POLICY_LOAD 1421	/* IPE Policy Load */
+#define AUDIT_TRUST_POLICY_ACTIVATE 1422	/* IPE Policy Activate */
+#define AUDIT_TRUST_STATUS	1423	/* IPE enforcing,permissive */
 
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
-- 
2.33.0

