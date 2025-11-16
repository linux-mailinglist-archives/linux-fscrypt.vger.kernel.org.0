Return-Path: <linux-fscrypt+bounces-969-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3E6C61299
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Nov 2025 11:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 29C1428D73
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Nov 2025 10:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B657286D4D;
	Sun, 16 Nov 2025 10:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="0BUuM5Pn"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E1F28641F
	for <linux-fscrypt@vger.kernel.org>; Sun, 16 Nov 2025 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763289421; cv=none; b=WsyR65TcVuFjR7yxcQVuViLKnZlJrpm28VrVBET0BZU8BOU4dKit11MaS/6zsf0pPXJYGm15mBwsSZ5zqAS8uz7+jdjqCDYVeQ8fkLAkMrA7qgJXZVUXSoKujY13UpfQvX9+1Zrx0R/CY4FvQD080er63pWDUZxu2vQlq5gGazc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763289421; c=relaxed/simple;
	bh=kiMW/IlmMt/llpJ0AhPrTQEfxQWr9GmclWgSQXm5Qj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEleiinnt1ztNrQMxfVDOfNggC4uZPHz25fqHsdoHK50Ha+kWbxyNJdCMf/Oi+loVuKT5njNOawThoOZU2TXUAGr5Y2RIhQFGEKHOhI0Jd9nlEcvU7G6hwkBzki1Dgci5fsAidu1J0k4Nbz9iolbW6FKH7jNq2OjwCy5bna2MDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=0BUuM5Pn; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aace33b75bso3139552b3a.1
        for <linux-fscrypt@vger.kernel.org>; Sun, 16 Nov 2025 02:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763289419; x=1763894219; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2xccyQL0wjRPHWCif7a/agPdP0N/MqlaSpRLb12d9w=;
        b=0BUuM5PncpIX4gC72ZeBeqGAoVm7WJWoHsc7iHU03TPriGYBKAi5KN+kdt8X96Aaom
         U51fdxYMHFpgFsHS/oICqBiwHnsCt5IQ6ipcG2r7bQw848z+A4HwViqmq+a8kDApLX5V
         rsTX+ceUU6uWaoxtowFDJ0BsfKmKhhOsVwB5YCiipkwMCatrxKoUBznXokuBrUlcdWWL
         YEyWZXmDIy5/2r1iIAgRGr8u7HtXRcODi8B+xSPKq6izhnh+H2I+23gI7hQ6aw1Jwe1V
         6ySC4MZS0LmjMmwTnu44iaLwlQDXjjf0/XMJFZbMz9S0LYCnh/qVUgjWrrnKwnfOA3Vd
         2U1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763289419; x=1763894219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2xccyQL0wjRPHWCif7a/agPdP0N/MqlaSpRLb12d9w=;
        b=txPcJT/MAR7eVPV95ARUMvdIDTbVE05TaAuRdJAxFPnudVjS97Oh3DQkj0OigH0Jzu
         72AAD9JRQKBtcZUd+ZVLbQCj8JEmb0e4084qPDq/xB/VvuBK7VeCowbJO1CTg+rdWciq
         d8U9AmLKMMzmqXRo/6bKJNElSRhZ/frpdVNAMKYVFmwGajA8uS8V8cXbnwh3oJYaa/gU
         /gmELhmToV2RUzrDJrAWrqI+U/BMXYAbqkq3ptNnHtsDA28Kj3RT8OT4wKCvJgRYaWJz
         g85oM9Mp1eUqPWncq6/vZ31lWnr/FLoD2IsUbyo0cqATNcVZ7IXwEfTEv5OrdpXCWDM2
         IKng==
X-Forwarded-Encrypted: i=1; AJvYcCViQ3c6dDel5BkyjCjzlMi7WcG8NMaT+6j5C5/6bBQ1ubuTddCXKjOyrjcGqbbpo0Ad91g/8IKp1cUw/5uR@vger.kernel.org
X-Gm-Message-State: AOJu0Yy76mWWPqNg63a6/4kAfEQcqx71DJzjDdmflZQxut1BOatgypWR
	Xe+TTRdbzEOFDHRD0Er2QYsAzrkKpcG+z3axQYsiKzEW+Yu8Zraoy/dowMLHLiMwGoI=
X-Gm-Gg: ASbGncvNvWerwa3dgpkhbXH/Gly3HWicM3DeUxUbzys6W9H3KWBH+Guosvv72zaOV5t
	gl00/dPfTpiL4htC3NBIFuSES2DqB98pV+QuZLBENh3Y/6T9q/UAjczlJ7cu/4QWmRZ+eCSxoRW
	E79U744/KaDtDMv6IiWC33UwwiHhxk22v6msWtOyBZ9roOXbBK9cwJysDZtKJ0fH5b3xWYbrfnK
	HbiNz1P4F7+K/QxwO27lGYWBPzqtm6SLxWy5GQbt/ZKbtJ6LUH9K0MLYnBzTeTrHNViQSdhGgfo
	MkcxHrjjPQ5dKxijma+catu9eHIIl2QerrYetg+mbadU2wz6SvZQnBBYcopVS4q4/SATwGvcoB8
	9TEC5rm7Gcd125CUEbYUZjRukDk/KT0tIBPUzi43WwmMpdPzKg5XLDDkdPEg4vBTFSHAJG1sa9h
	FSBwtgVZ+o94MArTk5Pwnt+xm8/AGF5Q3t
X-Google-Smtp-Source: AGHT+IEnf43Ltm/bA4lzbDQv+6sO2UhNpxxLrJK2n5FBPc4EJRJYJDkn08A4bHCQNvaKnyZ/h6JUVw==
X-Received: by 2002:a05:6a20:7d9d:b0:35c:e441:e6d2 with SMTP id adf61e73a8af0-35ce441e898mr7014829637.7.1763289418602;
        Sun, 16 Nov 2025 02:36:58 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:22b3:6dbf:5b14:3737])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36fa02c42sm9507887a12.16.2025.11.16.02.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 02:36:58 -0800 (PST)
Date: Sun, 16 Nov 2025 18:36:50 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	Xiubo Li <xiubli@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
	"hch@lst.de" <hch@lst.de>,
	"home7438072@gmail.com" <home7438072@gmail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"visitorckw@gmail.com" <visitorckw@gmail.com>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH v5 6/6] ceph: replace local base64 helpers with lib/base64
Message-ID: <aRmpQmMtfZQ8f95s@wu-Pro-E500-G6-WS720T>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
 <20251114060240.89965-1-409411716@gms.tku.edu.tw>
 <afb5eb0324087792e1217577af6a2b90be21b327.camel@ibm.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afb5eb0324087792e1217577af6a2b90be21b327.camel@ibm.com>

On Fri, Nov 14, 2025 at 06:07:26PM +0000, Viacheslav Dubeyko wrote:
> On Fri, 2025-11-14 at 14:02 +0800, Guan-Chun Wu wrote:
> > Remove the ceph_base64_encode() and ceph_base64_decode() functions and
> > replace their usage with the generic base64_encode() and base64_decode()
> > helpers from lib/base64.
> > 
> > This eliminates the custom implementation in Ceph, reduces code
> > duplication, and relies on the shared Base64 code in lib.
> > The helpers preserve RFC 3501-compliant Base64 encoding without padding,
> > so there are no functional changes.
> > 
> > This change also improves performance: encoding is about 2.7x faster and
> > decoding achieves 43-52x speedups compared to the previous local
> > implementation.
> > 
> > Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  fs/ceph/crypto.c | 60 ++++--------------------------------------------
> >  fs/ceph/crypto.h |  6 +----
> >  fs/ceph/dir.c    |  5 ++--
> >  fs/ceph/inode.c  |  2 +-
> >  4 files changed, 9 insertions(+), 64 deletions(-)
> > 
> > diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> > index 7026e794813c..b6016dcffbb6 100644
> > --- a/fs/ceph/crypto.c
> > +++ b/fs/ceph/crypto.c
> > @@ -15,59 +15,6 @@
> >  #include "mds_client.h"
> >  #include "crypto.h"
> >  
> > -/*
> > - * The base64url encoding used by fscrypt includes the '_' character, which may
> > - * cause problems in snapshot names (which can not start with '_').  Thus, we
> > - * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
> > - * which replaces '-' and '_' by '+' and ','.
> > - */
> > -static const char base64_table[65] =
> > -	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
> > -
> > -int ceph_base64_encode(const u8 *src, int srclen, char *dst)
> > -{
> > -	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> > -	char *cp = dst;
> > -
> > -	for (i = 0; i < srclen; i++) {
> > -		ac = (ac << 8) | src[i];
> > -		bits += 8;
> > -		do {
> > -			bits -= 6;
> > -			*cp++ = base64_table[(ac >> bits) & 0x3f];
> > -		} while (bits >= 6);
> > -	}
> > -	if (bits)
> > -		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > -	return cp - dst;
> > -}
> > -
> > -int ceph_base64_decode(const char *src, int srclen, u8 *dst)
> > -{
> > -	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> > -	u8 *bp = dst;
> > -
> > -	for (i = 0; i < srclen; i++) {
> > -		const char *p = strchr(base64_table, src[i]);
> > -
> > -		if (p == NULL || src[i] == 0)
> > -			return -1;
> > -		ac = (ac << 6) | (p - base64_table);
> > -		bits += 6;
> > -		if (bits >= 8) {
> > -			bits -= 8;
> > -			*bp++ = (u8)(ac >> bits);
> > -		}
> > -	}
> > -	if (ac & ((1 << bits) - 1))
> > -		return -1;
> > -	return bp - dst;
> > -}
> > -
> >  static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
> >  {
> >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > @@ -318,7 +265,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
> >  	}
> >  
> >  	/* base64 encode the encrypted name */
> > -	elen = ceph_base64_encode(cryptbuf, len, p);
> > +	elen = base64_encode(cryptbuf, len, p, false, BASE64_IMAP);
> >  	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
> >  
> >  	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
> > @@ -412,7 +359,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
> >  			tname = &_tname;
> >  		}
> >  
> > -		declen = ceph_base64_decode(name, name_len, tname->name);
> > +		declen = base64_decode(name, name_len,
> > +				       tname->name, false, BASE64_IMAP);
> >  		if (declen <= 0) {
> >  			ret = -EIO;
> >  			goto out;
> > @@ -426,7 +374,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
> >  
> >  	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
> >  	if (!ret && (dir != fname->dir)) {
> > -		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
> > +		char tmp_buf[BASE64_CHARS(NAME_MAX)];
> >  
> >  		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
> >  				    oname->len, oname->name, dir->i_ino);
> > diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> > index 23612b2e9837..b748e2060bc9 100644
> > --- a/fs/ceph/crypto.h
> > +++ b/fs/ceph/crypto.h
> > @@ -8,6 +8,7 @@
> >  
> >  #include <crypto/sha2.h>
> >  #include <linux/fscrypt.h>
> > +#include <linux/base64.h>
> >  
> >  #define CEPH_FSCRYPT_BLOCK_SHIFT   12
> >  #define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
> > @@ -89,11 +90,6 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
> >   */
> >  #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
> >  
> > -#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
> > -
> > -int ceph_base64_encode(const u8 *src, int srclen, char *dst);
> > -int ceph_base64_decode(const char *src, int srclen, u8 *dst);
> > -
> >  void ceph_fscrypt_set_ops(struct super_block *sb);
> >  
> >  void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index d18c0eaef9b7..0fa7c7777242 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -998,13 +998,14 @@ static int prep_encrypted_symlink_target(struct ceph_mds_request *req,
> >  	if (err)
> >  		goto out;
> >  
> > -	req->r_path2 = kmalloc(CEPH_BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
> > +	req->r_path2 = kmalloc(BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
> >  	if (!req->r_path2) {
> >  		err = -ENOMEM;
> >  		goto out;
> >  	}
> >  
> > -	len = ceph_base64_encode(osd_link.name, osd_link.len, req->r_path2);
> > +	len = base64_encode(osd_link.name, osd_link.len,
> > +			    req->r_path2, false, BASE64_IMAP);
> >  	req->r_path2[len] = '\0';
> >  out:
> >  	fscrypt_fname_free_buffer(&osd_link);
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index a6e260d9e420..b691343cb7f1 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -958,7 +958,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
> >  	if (!sym)
> >  		return -ENOMEM;
> >  
> > -	declen = ceph_base64_decode(encsym, enclen, sym);
> > +	declen = base64_decode(encsym, enclen, sym, false, BASE64_IMAP);
> >  	if (declen < 0) {
> >  		pr_err_client(cl,
> >  			"can't decode symlink (%d). Content: %.*s\n",
> 
> Looks good!
> 
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> 
> Have you run xfstests for this patchset?

Hi Slava,

Thanks for the review.

I haven't run xfstests on this patchset yet.

Best regards,
Guan-Chun

> 
> Thanks,
> Slava.

