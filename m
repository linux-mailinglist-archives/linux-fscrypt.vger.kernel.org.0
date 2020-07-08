Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310B1217D4E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2020 05:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgGHDF6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Jul 2020 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbgGHDF5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Jul 2020 23:05:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AB1C08C5DC
        for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jul 2020 20:05:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4so24342034plo.6
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2020 20:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sxoy6q+HxdTygJctVhkj+Ncax7HD8YrVRDBUHbmI/GA=;
        b=jvxGSCDzgqCSzD3A5CZ6zoxEY3HwELi8FObL00AmNlxQWLpvrUeBFZBc3B9zB5etbX
         mYEpJX0jRgUUJ4S9ot+BQk61eRDjpYkKZjXS5FkMSOUavjWBlMPiA5+LW/699y0iXpQC
         s8ynNf8lIHMTPkHzVRmSAVfDowYI++DiMfl/exKk9l+l/8eEG3w0s91A1Ycqqyju5MfB
         hrssrkk130gtKV4YYHCQ2dycaO4RT4XQHdC+kpGmlUYHSXN8zNcGMq9fWspZLGH9mYPU
         dePpa1pDLmtFFKbvxkZX6SahRyc7gjEHircUdtQBKPXrVPw+ESEA+mxA7Fqh1xXzohzl
         +nKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sxoy6q+HxdTygJctVhkj+Ncax7HD8YrVRDBUHbmI/GA=;
        b=V8X7XQ7a1hNbv+dRHI/AIIGfrkPKT3ip1rdyRCtok23D/IRu1Fx7s61JvBNHKLUwH8
         T3Ay2od3NTj6Qj5JhpnBoMaDJBkXXGNtJ1g5rB7nadmTbO08AMK7UDDCIbpaI//ajImo
         Nbk4FmEkxaDSWGSuGi0aAYemJT4UDmYkufmE/krnZ9WS5tGPGDzGqrwQngqLt7iMwlvG
         D4obJCzRo4ehm45O9niesjUmpIstirqbl4tcyQFGv4/g8SdR0lF2fmLZARRZ37/Uxak2
         o5RsHWYUQKgF2R9WncD7aD3v6/sLXPZMg7ULAmBtZGO2vAzpCHAWm9byvQ3oBrN9kzbe
         ZP6g==
X-Gm-Message-State: AOAM531C/QdQfpB9YPWG5m8GKQqUeHECym3n9J2f4JefSTy557FTt8Fg
        VVRyqggVsL9OikeOkahemNKP1T92Mo0=
X-Google-Smtp-Source: ABdhPJxHc+FKhRyKZRaUpdsFwS/kCIg/eIMdmz1LxIxSnZIjP9Kv5YSfmEOlULOG9PgVuLCQSbtYJSctP7g=
X-Received: by 2002:a17:90a:1fcb:: with SMTP id z11mr1032734pjz.1.1594177556279;
 Tue, 07 Jul 2020 20:05:56 -0700 (PDT)
Date:   Tue,  7 Jul 2020 20:05:48 -0700
Message-Id: <20200708030552.3829094-1-drosen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v11 0/4] Prepare for upcoming Casefolding/Encryption patches
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This lays the ground work for enabling casefolding and encryption at the
same time for ext4 and f2fs. A future set of patches will enable that
functionality.

These unify the highly similar dentry_operations that ext4 and f2fs both
use for casefolding. In addition, they improve d_hash by not requiring a
new string allocation.

Daniel Rosenberg (4):
  unicode: Add utf8_casefold_hash
  fs: Add standard casefolding support
  f2fs: Use generic casefolding support
  ext4: Use generic casefolding support

 fs/ext4/dir.c           | 64 +---------------------------
 fs/ext4/ext4.h          | 12 ------
 fs/ext4/hash.c          |  2 +-
 fs/ext4/namei.c         | 20 ++++-----
 fs/ext4/super.c         | 12 +++---
 fs/f2fs/dir.c           | 84 ++++--------------------------------
 fs/f2fs/f2fs.h          |  4 --
 fs/f2fs/super.c         | 10 ++---
 fs/f2fs/sysfs.c         | 10 +++--
 fs/libfs.c              | 94 +++++++++++++++++++++++++++++++++++++++++
 fs/unicode/utf8-core.c  | 23 +++++++++-
 include/linux/f2fs_fs.h |  3 --
 include/linux/fs.h      | 16 +++++++
 include/linux/unicode.h |  3 ++
 14 files changed, 172 insertions(+), 185 deletions(-)

-- 
2.27.0.383.g050319c2ae-goog

