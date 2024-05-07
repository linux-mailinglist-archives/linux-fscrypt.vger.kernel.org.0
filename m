Return-Path: <linux-fscrypt+bounces-278-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A268BDEBB
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 May 2024 11:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B155281344
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 May 2024 09:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D860E14E2F1;
	Tue,  7 May 2024 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byqIhEGF"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F36E61B;
	Tue,  7 May 2024 09:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074650; cv=none; b=jciFh5BN+8nBmaLJYNsBBPjQGGApOXTNJZPMf82ugpyyuLmEr6XjyF2NcChcLGbZkLqJ0TXURAiRzNzcLZoJjaNG9p7gT2uT4t1b+8N63KgqFeFlzxVWp5axfewZb9y4jH6I7RdqYxqszDWYDnMdW+VFGJFFIUxGeWoey36cRlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074650; c=relaxed/simple;
	bh=RM8ecK6sFi/vogUypaZKYRK7sq1fWu1V3XPe+SMN4ns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dUvTuldosdWabK9MiRXEMo0prrZpdWt+hIv+smMO2qZKktAz0CWVb43ddfUwAVbHBmD6czQNM7YR2eJMaCH9P9VurJx7nZdkU3+JnWrxkb5lCAPiBj/AOe6nyJmaC+hfvu4mXprKObmMGdwcdC/0UH7yyMGgw7gfAg2QdJJrdTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=byqIhEGF; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2e3e1ad0b19so8278301fa.0;
        Tue, 07 May 2024 02:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715074647; x=1715679447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MjEE8E6ryWIUb7zrvHx2Xl9/PlP43pMdw3xy20SDzeY=;
        b=byqIhEGF+AYkPMr0Eq4GG4rsUCv9z/xTtt5tk9L5hLxpyiDKoUOzf8pKHsYEV8e6zw
         Nc6Z4nMZe0n52wPuixrNyoeRR0UfZGWiVCT2pRrXh8qLDwZTtB1JnEwlqbHWzmiCwoYh
         5U22gpjZXy7qgS0wMdwtK2aXwklHM5YZ62SwiRs/Z1II2VAC7Vff1FLlUJMFQpmgVFZI
         jRKED76nDGdsYn4x5c+MxfI26aeqYCEBULykQ7saHsYJuUmt7ekJ1bAitia2eMmQS9W9
         sUyUrD/mEs15CE9S7o61oIYIjBM3RkLTeCHb9rcxIM3PT7SCDeuiCZaTQfkbmJruRtOl
         qW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715074647; x=1715679447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjEE8E6ryWIUb7zrvHx2Xl9/PlP43pMdw3xy20SDzeY=;
        b=jENif85rEyobqZmEsrAmVEN02iqnQrdFwxD6fyHhirki+BQhD+UE/GSf53TjHPFIVq
         M1eBT1yOTdAPcz8Ou5+uKONJifc9FD6iKA8zUQwFUWM/HGVj28tNOaX1lu8wi8/W8vmL
         thIDkuZSnd0Ry5xaFp/c0hlVpm0Z8F+K4J35hhvTTACdLA2+8yaCPNHCByIi34yO3wAz
         2VkADhPZ+GcmPozVbcwl1Q12sHHDKUIf+mxdphABm0u5QMvbWAqvWV8Wr/wrxa39TbTO
         qL7BJEijzBSkA7VoHYpAGH5Sf5cRcTQYSLpREYAj2ANmBv70HnMRuz6Mw25jJV9/vIC8
         lPvg==
X-Forwarded-Encrypted: i=1; AJvYcCXdFNUKnvMiF4mxWJ5+oh+ln9X6F5p6+8Uyys5benbxl6kY+CaEbVqU8+9odDbkKP7gqYX+MY8FkQmlQMWMzdKLV8hMTMkD5QPPsqAemN3Gi1oQKXI7C4+fGZ0NoZZtXZTmZd/WD7cn7PazAg==
X-Gm-Message-State: AOJu0YxYOJrNz4LvDMc2MGVVuSaqZ7nDBbN+Q9ZtPk2Cd865Jb0wMlZf
	nJNWapnNqNvQf+6qUUlr8pGa0NiOu3UZyu6gLECGW+MH7j65ej3Z/hD60Q==
X-Google-Smtp-Source: AGHT+IG4kP44y9LBnB6Gb0NRCn1Q1gM+S/ffoRVzDyB2qwPMZ8jMbaTmgJKxOHWHznUlcueebE6gcA==
X-Received: by 2002:a2e:2406:0:b0:2e2:5fd:7030 with SMTP id k6-20020a2e2406000000b002e205fd7030mr7918797ljk.13.1715074647042;
        Tue, 07 May 2024 02:37:27 -0700 (PDT)
Received: from f.. (cst-prg-20-30.cust.vodafone.cz. [46.135.20.30])
        by smtp.gmail.com with ESMTPSA id k8-20020a05600c1c8800b00418a6d62ad0sm22891128wms.34.2024.05.07.02.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 02:37:26 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: ebiggers@kernel.org
Cc: tytso@mit.edu,
	jaegeuk@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] fscrypto: try to avoid refing parent dentry in fscrypt_file_open
Date: Tue,  7 May 2024 11:36:53 +0200
Message-ID: <20240507093653.297402-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merely checking if the directory is encrypted happens for every open
when using ext4, at the moment refing and unrefing the parent, costing 2
atomics and serializing opens of different files.

The most common case of encryption not being used can be checked for
with RCU instead.

Sample result from open1_processes -t 20 ("Separate file open/close") from
will-it-scale on Sapphire Rapids (ops/s):
before:	12539898
after:	25575494 (+103%)

Arguably a vfs helper would be nice here.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/crypto/hooks.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 104771c3d3f6..16328ec14266 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -30,21 +30,32 @@
 int fscrypt_file_open(struct inode *inode, struct file *filp)
 {
 	int err;
-	struct dentry *dir;
+	struct dentry *dentry, *dentry_parent;
+	struct inode *inode_parent;
 
 	err = fscrypt_require_key(inode);
 	if (err)
 		return err;
 
-	dir = dget_parent(file_dentry(filp));
-	if (IS_ENCRYPTED(d_inode(dir)) &&
-	    !fscrypt_has_permitted_context(d_inode(dir), inode)) {
+	dentry = file_dentry(filp);
+	rcu_read_lock();
+	dentry_parent = READ_ONCE(dentry->d_parent);
+	inode_parent = d_inode_rcu(dentry_parent);
+	if (inode_parent != NULL && !IS_ENCRYPTED(inode_parent)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+
+	dentry_parent = dget_parent(dentry);
+	if (IS_ENCRYPTED(d_inode(dentry_parent)) &&
+	    !fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
 		fscrypt_warn(inode,
 			     "Inconsistent encryption context (parent directory: %lu)",
-			     d_inode(dir)->i_ino);
+			     d_inode(dentry_parent)->i_ino);
 		err = -EPERM;
 	}
-	dput(dir);
+	dput(dentry_parent);
 	return err;
 }
 EXPORT_SYMBOL_GPL(fscrypt_file_open);
-- 
2.39.2


