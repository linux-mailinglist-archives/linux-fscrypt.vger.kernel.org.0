Return-Path: <linux-fscrypt+bounces-1074-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNijOfYKd2lebAEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1074-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jan 2026 07:34:30 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 660C884915
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jan 2026 07:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 79D663005769
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jan 2026 06:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A67027877D;
	Mon, 26 Jan 2026 06:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cE1Purqo"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDF81F30AD
	for <linux-fscrypt@vger.kernel.org>; Mon, 26 Jan 2026 06:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769409244; cv=none; b=VMXWpB3TTp4FRmi4wPLaN9UbLy3reeL42LjpinR/zNEhB9/Bs6jUch4JwaxqUn4ECnOO/tPRM426p1oIFI7kvr0J51QXIBrMjukS0GJVMhVgOLguvtOpOnU9j4cp8V/mkljNz/2UePO1cuieC61rJ/S44jtu4zTPt0CDc0tN1fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769409244; c=relaxed/simple;
	bh=EgSzs1OlDMh3Q8s54ZdjDobeqnp0CHOi/M2J0zDVHrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nxbii+Gv4dM073+nDPQTT6WaW3r9RPpIHm80yI4+Lv9hWPN3wu/se7qG9qPyiB1r45ZmPaNAgv2OcK/+UCQCJq0xsM6YEXshNuAx5kM4Hpm8+XYRpJ53qRgZthITL8qcgEweF+SU68KtDag7vRAaO5if2qhZEzuLOZT7XT/jEmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cE1Purqo; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so45395375ad.2
        for <linux-fscrypt@vger.kernel.org>; Sun, 25 Jan 2026 22:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769409242; x=1770014042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gv0Zz9f3QcNoHEU92zzDKUJ9eJrwLyE/kmgjH7ImIcM=;
        b=cE1Purqo6//LQWryxgefMfcUC0UOwWL7p9h7QWgjFbtGOpo5kH02WYfPHhrlTvQIJ4
         HiiXdnx+Vene8gZzh5qaent8BXz3RP/6Yt1X4hbgujo8/JsNCAAnzCOQod/6bTFOK8DU
         OydY8mpi8PdVSELHDW3c+GfBtW4tG3fzOJh7rJGUHklPIjYN2I+zUSQxOC1TUHQymPGA
         5g8UuRQzq9kYT9sgTWv85NtLm2k0hBkcTw51iPpRz3UvPQVpaE/FsfAN6jdNgeSAFhTU
         y7S9KYfnRQODlKGYEsyEpcr6kzjPwrgJf6qv/jM5eBp4i4vAKsBsbBAMn9Q2j73/rW0G
         Ur4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769409242; x=1770014042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gv0Zz9f3QcNoHEU92zzDKUJ9eJrwLyE/kmgjH7ImIcM=;
        b=KQCNly0nGAFsJSX6rMvJd6R1t8qP2OsPvD67eWtb2ac6FmnWTcXebS3cl9Kug4Yqs4
         Cm3zMRAWxOZ/+R42HmX1w1pqG46DESCVVwiycCoTzT9rJ2SwJXXyx0y/aU/dvcC20Zsy
         PiGnM2qoxj3HvqVwfOJLZD3/CZQUZvqeI/PDtw/rRaD1sp04whyxoqIU+MR/SFxaB1mm
         NsdfTxR2YRzMeY80WBG5QXO1j9lmVs50prToXXcvplzL8muaorckgxUjDCt4sbWHFU5x
         jtdfKI2i5OzUE7QqO+fRkw1Fhu6qvaeNeHYALp25+B40sad9lYoOJybOu2hlRsLZBkSC
         mo+A==
X-Forwarded-Encrypted: i=1; AJvYcCVc+g8MSxmifncvrJ64cpNvfgpGEu+MFCZ2xPfysRUQx1cBfVbAlyvxBbG56Kv7I8JrHIZaPBxY9pyGCE9f@vger.kernel.org
X-Gm-Message-State: AOJu0YzCgJzpbaKGaRLfT5IF127H6N/Pg0Me8kbeDPMqS35sR+Admr9n
	7ybYb+BYKYB3LN/xYn5E0XAEick4xNNKjnnDpUE/0C0DbT6el8zdFIkU
X-Gm-Gg: AZuq6aJLTzKYxN90MTx1hriyHa1IelU2yfiilWB1Mdl/nXF9MJzmqayRiLSIH4ImVHq
	QdLZWSX0ccweAw2vNx8CxqFepj4bFmZwi5inyzSms4AYCcapcmFmGrNeeehDqhU3oWIgsC+uXLC
	5r704xplsCMCTJbrpvB4+w20Lr+x7GW5tpLpGNxfPmMx+QvBqmLBY5IkdoHmIL/BRZXN27yjsAw
	xolih3wGu0Jk8r0ZNAF1QoB7i/eKqMV9T19KgazvXVayFdcA1upHxorSm8XJqsy+1u1FveMxKQ6
	zO0cg/xIPYkRrhcvIxc/NNySca4ybHaa+o9Qk9i2HiAodFfUDOKpqSlJZfCa92wYLDed7jdoomp
	zMYN3zz0QjSekNOKo1a8wfWGHnBG3k6iZy7egFRWvrea1iMRRPs5o8IPt7PQEKt0cz36QqJzyn5
	PSwEOhITyR6CbaOQVx29+Xd4vTpi9KNI1a+NAHzQ==
X-Received: by 2002:a17:902:d511:b0:297:e59c:63cc with SMTP id d9443c01a7336-2a8452b16c5mr41391845ad.35.1769409242273;
        Sun, 25 Jan 2026 22:34:02 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.220])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802dcd8cdsm79352455ad.27.2026.01.25.22.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 22:34:01 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: ebiggers@kernel.org
Cc: jaegeuk@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	tytso@mit.edu,
	wangqing7171@gmail.com
Subject: Re: [PATCH] fscrypt: Fix uninit-value in ovl_fill_real
Date: Mon, 26 Jan 2026 14:33:55 +0800
Message-Id: <20260126063355.504157-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260124182547.GA2762@quark>
References: <20260124182547.GA2762@quark>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1074-lists,linux-fscrypt=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,syzkaller.appspotmail.com,mit.edu,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wangqing7171@gmail.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[linux-fscrypt,d130f98b2c265fae5297];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 660C884915
X-Rspamd-Action: no action

On Sun, 25 Jan 2026 at 02:25, Eric Biggers wrote:
> For KMSAN issues, it's important to root-cause them.
> Zero-initialization isn't necessarily the right fix.
> 
> In this case, it looks like ovl_fill_real() is incorrectly assuming that
> the name is NUL-terminated.
> 
> Yet, the name passed to dir_context::actor isn't normally
> NUL-terminated.  Even for a regular directory, ext4 just passes a
> pointer to the filename in the ext4_dir_entry_2 in the buffer cache.
> 
> The encrypted directory case doesn't seem to be fundamentally different.
> Just KMSAN is able to report the issue because the memory is in a slab
> buffer rather than the buffer cache.
> 
> Can you consider fixing ovl_fill_real()?  Instead of strcmp(".."), it
> should check whether namelen is 2 and the first two chars are '.'.

Hi Eric,
Thanks for your reply. I agreed with your idea and resend a new patch.

https://lore.kernel.org/all/20260126062216.496560-1-wangqing7171@gmail.com/

Looking forward to your next review.

-- 
Best Regards,
Qing

