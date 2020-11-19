Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71862B8B4D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Nov 2020 07:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgKSGJI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Nov 2020 01:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKSGJI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Nov 2020 01:09:08 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408D3C0617A7
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Nov 2020 22:09:08 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id m17so3768037qvg.5
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Nov 2020 22:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ANbu1Df+KdZWLGFVKIuoVXDzF2gJVrXKwqf/2x+Sgns=;
        b=c6PEOqqB1y53GrJM29i1IJOo4HV+KBw2qDYjjOmo3Lwic4AiGfQBHqg29ajW15QvO5
         VEJwuKDRs4rD3iyUSjV08gc0kn4Usqif1RBjXIj3Vj2gh4jZmHN95C5ewXA0Ilpniu03
         mgu3gBv+mEHKHmf8oQjXZwmOy2XfLEFOAGvCsAfevMnnIyEEkLE8DsIkAw8ahjs8WSl5
         khD4T/rIpxE2eqoBJXFSXgEWFUgDdmRAz6wrLPtZmCSuOUS+lnwS0q0adeZgnYAJrioL
         TdLT+x8VODOw3i7smRHF2swF/AHnI00L5YyqI53TuB4YP9a2sgNPeqSwZmuNFNPddSjG
         BUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ANbu1Df+KdZWLGFVKIuoVXDzF2gJVrXKwqf/2x+Sgns=;
        b=Y/w1YzJsw0FreTanzZEw0UP1o4hlVz59fINLsKsRbx4m/9MrRtAwNuPnb5sn28aYYd
         Rrf+gIqRUn8M6Z+NxxZfhvt8JAPNS/ldqWd1Z90rXPbmk7CWXDJp5GKzEpNT6C2yB0nV
         QRC0RymQ4ozQV1TZ02hWVKHmueJwK3HVtiRq7nFRXpHoLr+xvrtOW7sE5s2synR/kOWk
         4QBXun8dmLfhTNA08aUVAmTv9XYlA/Lx/u0Xv7tgI6sQ7SyBt6XPoS+XmyGk0Z1oVCj3
         cMMZaqO5CQ7sLHs4U0EIZSXmZYQdgOkJ39mpFl0x0PQiJDgD86sE3FX24B5BVwK08enT
         0IxQ==
X-Gm-Message-State: AOAM532i+nKTgtiW/km7sPub1/xtg8dWud4QAte5qSk4LHzgF/Zt6Qey
        vlBPdd4bFfZeQFZOaeXBZDfNBU8a11o=
X-Google-Smtp-Source: ABdhPJwON+zdFtliqZ+ma3jEjb9UxZ0ne5Mm+ghwPkKFU99I/CIoH/3dozPBLOiAETaSOGqDxwavxcB+6fo=
Sender: "drosen via sendgmr" <drosen@drosen.c.googlers.com>
X-Received: from drosen.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:4e6f])
 (user=drosen job=sendgmr) by 2002:ad4:490d:: with SMTP id bh13mr9760846qvb.14.1605766147299;
 Wed, 18 Nov 2020 22:09:07 -0800 (PST)
Date:   Thu, 19 Nov 2020 06:09:01 +0000
Message-Id: <20201119060904.463807-1-drosen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v4 0/3] Add support for Encryption and Casefolding in F2FS
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

These patches are on top of the torvalds tree.

F2FS currently supports casefolding and encryption, but not at
the same time. These patches aim to rectify that. In a later follow up,
this will be added for Ext4 as well.

The f2fs-tools changes have already been applied.

Since both fscrypt and casefolding require their own dentry operations,
I've moved the responsibility of setting the dentry operations from fscrypt
to the filesystems and provided helper functions that should work for most
cases.

These are a follow-up to the previously sent patch set
"[PATCH v12 0/4] Prepare for upcoming Casefolding/Encryption patches"

v2:
Simplified generic dentry_op function
Passed through errors in f2fs_match_ci_name

v3:
Split some long lines
Cleaned up some code
Made some comments clearer
Fixed bug in v2 error passing

v4:
Added reviewed bys and acks from Eric
Removed unneeded variable
ifdef consistency

Daniel Rosenberg (3):
  libfs: Add generic function for setting dentry_ops
  fscrypt: Have filesystems handle their d_ops
  f2fs: Handle casefolding with Encryption

 fs/crypto/fname.c           |   4 --
 fs/crypto/fscrypt_private.h |   1 -
 fs/crypto/hooks.c           |   1 -
 fs/ext4/dir.c               |   7 ---
 fs/ext4/ext4.h              |   4 --
 fs/ext4/namei.c             |   1 +
 fs/ext4/super.c             |   5 --
 fs/f2fs/dir.c               | 105 ++++++++++++++++++++++++++----------
 fs/f2fs/f2fs.h              |  11 ++--
 fs/f2fs/hash.c              |  11 +++-
 fs/f2fs/inline.c            |   4 ++
 fs/f2fs/namei.c             |   1 +
 fs/f2fs/recovery.c          |  12 ++++-
 fs/f2fs/super.c             |   7 ---
 fs/libfs.c                  |  70 ++++++++++++++++++++++++
 fs/ubifs/dir.c              |   1 +
 include/linux/fs.h          |   1 +
 include/linux/fscrypt.h     |   7 ++-
 18 files changed, 185 insertions(+), 68 deletions(-)


base-commit: 0fa8ee0d9ab95c9350b8b84574824d9a384a9f7d
-- 
2.29.2.454.gaff20da3a2-goog

