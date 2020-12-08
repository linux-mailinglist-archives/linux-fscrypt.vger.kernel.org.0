Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE62D27D7
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Dec 2020 10:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgLHJjE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 04:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHJjD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 04:39:03 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D3AC061793
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 01:38:23 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e2so3356872pgi.5
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 01:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x1xsP4hi+UGnP2yxtDqsufVew2mnlvtx1BXkv0GZN90=;
        b=eJKHIJ7oh3DpeexTdsuQEJnzvwrJ12Rl31xgSVrkzcb/aZZYka+igWw1YO2PtWFB1J
         rxhPC50Vyx0iG9Cv0NV/2bZzoTjchW2CQNOftmmF2qoKbny/RO5hnJGA1TFooI5p46vM
         V3hLYPyau1rDL4bT8/Dhto0x7gn8cHdXxjkgY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x1xsP4hi+UGnP2yxtDqsufVew2mnlvtx1BXkv0GZN90=;
        b=d0gTLU7qbdXktXK3nf/b38tRCv++7okZ9GD1GjuNCzW69e886sNgS7h5QwERyoZE9G
         T4YURxHTXiMNZCN3qem+QW7T4BeTHN4o8sdW3zhraXYo3NjZDeVeDyqmYhMVTiYw31gY
         u4TYK6SPZB118hUJM33YVmi7geW9XlwwwoUxV1XPPHVf1qW/IjJzjm6ARqblU105akJp
         MIR9zVRxTEXijq9dEVHKAkASO8Iapc33gzfXNEiugxd91u3aAcdsLr2+klfvUMMSITCr
         iAGNju3i3CdLqKxRccl1w5aU2fRfY7X1F+zH5IWqUpoqMHf5/wBhRHTcyJCmbX9G2fhz
         AOkw==
X-Gm-Message-State: AOAM533oXIvXSYscMlHqmyFbt6gG9NRPSMLizllzzEwzvFp4OVixEhAI
        1AYardGvoQJPEVk9E9MuT+VJlA==
X-Google-Smtp-Source: ABdhPJzz4+LER4Ucs9KFsZC8AVR333BX5objLsX8hHl7a2LaE2+WqTD3hzdG2uTXKcPBbZkmH0u0LQ==
X-Received: by 2002:a17:90b:b0d:: with SMTP id bf13mr1617624pjb.194.1607420303307;
        Tue, 08 Dec 2020 01:38:23 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f693:9fff:fef4:2537])
        by smtp.gmail.com with ESMTPSA id 129sm12316232pfw.86.2020.12.08.01.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:38:22 -0800 (PST)
From:   Chirantan Ekbote <chirantan@chromium.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>,
        Suleiman Souhlal <suleiman@chromium.org>,
        fuse-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: [PATCH v2 0/2] fuse: fscrypt ioctl support
Date:   Tue,  8 Dec 2020 18:38:06 +0900
Message-Id: <20201208093808.1572227-1-chirantan@chromium.org>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201207040303.906100-1-chirantan@chromium.org>
References: <20201207040303.906100-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series adds support for the FS_IOC_GET_ENCRYPTION_POLICY_EX ioctl
to fuse.  We want this in Chrome OS because have applications running
inside a VM that expect this ioctl to succeed on a virtiofs mount.

This series doesn't add support for other dynamically-sized ioctls
because there don't appear to be any users for them.  However, once
these patches are merged it should hopefully be much simpler to add
support for other ioctls in the future, if necessary.

Changes in v2:
 * Move ioctl length calculation to a separate function.
 * Properly clean up in the error case.
 * Check that the user-provided size does not cause an integer
   overflow.

Chirantan Ekbote (2):
  fuse: Move ioctl length calculation to a separate function
  fuse: Support FS_IOC_GET_ENCRYPTION_POLICY_EX

 fs/fuse/file.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

