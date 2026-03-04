Return-Path: <linux-fscrypt+bounces-1494-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uBqrLJHrp2lDlwAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1494-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 09:21:37 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 183F41FC759
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 09:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 949AE305A403
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2026 08:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D6338239E;
	Wed,  4 Mar 2026 08:17:05 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCA72F3621
	for <linux-fscrypt@vger.kernel.org>; Wed,  4 Mar 2026 08:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772612225; cv=none; b=N7xZfBbd2bTnVfETk9jcGuakMZNQDlx76n87Y+7KF4mHh2hEjizhsoS0JMiQHNcltDVx2tF+cgdozLwktdbnUe6FpeoTtqnpGtPfjhIXK45n+w01hCN+I2GPn4Dc/B1PVoEZq14ZWtBVi+M3+VSdi330MvkWlUua8csFY8nIER8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772612225; c=relaxed/simple;
	bh=xbYIMKUCvGTGTN9FX/e00guXBBK1mXcFr24/rAWTe0w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=lArjF7fJRV8LsfQ83FRY8IBiqi3pf3ZVnQdhSyvcy5z52uxDXDaQpAzrZNDLF8wL0uxDTvxxj4yzK8D9pyyS9JhbVgI7MXKPs6orH46i/fguy1h8kZEYDlWdnA3DYUh6LdPOy8ycTbfKdOc26mKhqDywz7rr1p9nnhPtLcJ/bZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679c6ef156dso55298841eaf.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 04 Mar 2026 00:17:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772612222; x=1773217022;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BjrWURK71SeP1mZA+fyGcBQJ4Fnq0aIU73n4Nn6FsVA=;
        b=xEMIUdH+f5Fmk1qBs6GJd6gQ0lFOt6J7ByIYl9puFylRZdrkXfAglU704A2vyh0YUB
         y2t8kglzXHbitGWV7PvlIUu+ifkGCTghJlRSEVHbhWwQhHfkOiL9rewTxou22cBypMtp
         wb6XWhuMevYC6FCi5Ml2HWRuNkxpw6ZAFhXEUkB8sOql6H6s7pClkD3Xiw0N8mGa2Kea
         fPhGWqb9YPZ4qhDzbZf9Sb2BxxyipfVbqewOlPSk6bf3lFBKIeF40gIcFCchFB9HZaSJ
         +H7+9FnpA6VSPGZofWUxlOf3naQVS/p8qC10yzHl908gjVxw5rqNztoNyee7vnsyUuvK
         /CgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ5h7sDJlaH3piQsN//3N4oiTHKb11tu17VnD0wRhecyi4mGgcnDC/D8DP1sBVnMvILerCsTVblo4LDFPf@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7X9XwUw+JsSLzkeMhz0nbEEg2feDxIIBF0vglJ2yQYXd+stRe
	TP0RpbdZUuCrC9boyE1MGoTmPzcZNP+gArEIIHIu1Zd8l2SLFeIW0WbJ1eZOy4ufIuEK65nk/GA
	HsArQa0olgcikGHhDBi6jZGsZ8LxQ1UAijAlICrh0lrgwfBAQ5ooVBec8HFI=
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9e:b0:679:e595:ff30 with SMTP id
 006d021491bc7-67b17750586mr873178eaf.36.1772612221934; Wed, 04 Mar 2026
 00:17:01 -0800 (PST)
Date: Wed, 04 Mar 2026 00:17:01 -0800
In-Reply-To: <efdfa39e-78f5-47df-9de5-a5d8ae8841b2@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a7ea7d.050a0220.21ae90.0015.GAE@google.com>
Subject: Re: [syzbot] [fscrypt?] [f2fs?] memory leak in fscrypt_setup_filename
From: syzbot <syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com>
To: chao@kernel.org, ebiggers@kernel.org, jaegeuk@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 183F41FC759
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=9d985797319d4da8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-1494-lists,linux-fscrypt=lfdr.de,cf7946ab25b21abc4b66];
	SUBJECT_HAS_QUESTION(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.990];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,appspotmail.com:email]
X-Rspamd-Action: no action

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com
Tested-by: syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com

Tested on:

commit:         be41931c f2fs: fix to avoid memory leak in f2fs_rename()
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git bugfix/syzbot
console output: https://syzkaller.appspot.com/x/log.txt?x=135fb006580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d985797319d4da8
dashboard link: https://syzkaller.appspot.com/bug?extid=cf7946ab25b21abc4b66
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

