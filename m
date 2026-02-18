Return-Path: <linux-fscrypt+bounces-1152-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2I7KCtfRlWlEVAIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1152-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:51:03 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D35B1572DF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00D45301AF48
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 14:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DB333C1B7;
	Wed, 18 Feb 2026 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Btz8khYt"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F0E33374B
	for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771426256; cv=pass; b=CQw/KAwS9bAp19umRIIwH3CV/1fl2dWSopHcV/tWywXuIH5HMqeuQKoe8AJTjONQsaRFpz9W5zsuLQCtLHHcQQXi5uiJzhi35N0j4hpnCnHrWBlyAPvTBaUiclwDcjkWPB4DYszmzBazU/Lp3G5R6VJSUZ/X+QsD+CAUnPYiKmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771426256; c=relaxed/simple;
	bh=ayix/lpTEKTXsxUj2iKsjlFXfV7GOzT2zS6Ou5e131g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZR7uZSXmSsEkXaKegZg5Y8TnxKKZU1PR0I6C6pW80eGNJcdH6EuquHLRc8ob86GbwMLS0fac4wK6M6Ds7c5IE52bj/cZ1aBP7xwuks9H+PAsCQCO/zUJkXhA85lADWrrAtoaapIi+OMYJrVA6qCwWZRwIAwVvophQDMqfSktMbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Btz8khYt; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-436e87589e8so6438649f8f.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 06:50:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771426254; cv=none;
        d=google.com; s=arc-20240605;
        b=EWRiRl0VLBUQAVpGRqjyVaGGFLwti+MlZrp+m1W5nNJjlQiNdeEBOcaCulez/hidja
         ZmmYkwgk07LFwM8Dbhd9hAvFPWC8x/8i9Nxuh1r+wWChxz6D5H4WlDM9jlSlj0b7lbGN
         pZiwKd+ZURxnk9n6S9Slir7HT5C0xPj5NH05f18MrGPR8dX3a+lD9rlFE7LHoAt/HgfM
         i5cE5Yes7XMNHodvOWEJf8R2aJjcI+liTQxtVk5Ba2NcwBaY5C44JZ+/7uuUVM8oztoV
         EO2bbDMmwjITNL3VlFkezjY/hBfVYVheqdjAzUtLCYa5v2RGJuso/uxh+OfLibZG7AEs
         cxEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XgscmaEOFxBbw8YrW9Yjg3xpxOoa9kw0yRjQzXqorpc=;
        fh=sq6B67ronyro2PD8RT71vf5g4kz1ocrVkKNvpDUpjvU=;
        b=kvCKTl9KQoeVtd7seR0rnBqYw8nsSkYc7PwNmT3DHME/QsKy4GRbE0wJcIIbKCLsEB
         ytceZYH10GLhXSrFz9b3tlRAAdrvB+eEXk4pHEC/ejvVtdDXwOtq3neOYFN3yBEHSytv
         I+wigFdlmS1KicqFt2AmfRxbzrGZ99bYLQRrESPwKx4jKRYW+vA4QT3PRt60q+O5Soo9
         rrBk2hkZuK+2MOPsJkETEMJB2kM4yDjf+SP1TZ28cEV2OOUOqF7ez8DOovSsGhUY+pdM
         3/KZ93eYWIXPrUd2GYSyc7TiFYWHG0Ew3XyfaEk+CyttHy2DvSX1rULqoO38WKsn0Rax
         YqHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771426254; x=1772031054; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XgscmaEOFxBbw8YrW9Yjg3xpxOoa9kw0yRjQzXqorpc=;
        b=Btz8khYtvNNsriVVeD6o6jXJ0W2Zjd7ItjK9kGtxHF5uZn0F5QYETeWA82Y7lAVbrW
         yOQ6GtzDcDWe/G5oPOHJNjHzsZXf05USpHbBMIipOB3s7eKpXmDec1mzLJ2OH5T/s+0J
         Z/Vc0AqWQ+cLF7wop8hhzL5WfTkLd6hQHLIKVREKCqJkxO844CVseJhe3vYj1Bh+eHJ2
         iIjdx9MMC4kLwixNEVvqD4EsyN3YAynm84fmsxoPNV3KskrOS/rKWKvbrAtf1YYV/QT4
         dX6q/hlUf6TSdswnyntXVAnnCgPVeDg5/om0obqPjDIOVQVYytb1jrq08em9DV1YqqdJ
         yLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771426254; x=1772031054;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgscmaEOFxBbw8YrW9Yjg3xpxOoa9kw0yRjQzXqorpc=;
        b=A/SUu7KZkGY00H8CEXnSh6YhjkSCKyD2f/XJsnuZBxFYAGRUBfl7gPPFjlId+eL8x8
         TS0gfQ51+vzlZFkn0dn81sJbGtu3XgzEdJSkkKqRVLYba3gJjyrIf/mpQ9801GvpDtm0
         iZOLK13xBNv6zc3m49q92dn2ug0bRFcSSK2WAUaI6AS1Vn1PAST6OGYxIgZwaKUpeE+h
         AC2Z25QS81B3j0hJz3kYxmjPgJbt9kYJI3KIS9j8icrotHsA7imOc+8a7+yT37bhfFmm
         /n3HX7bwAito+9oGhEXetWmHksSGRwxxxksUYGJlcGgSCsu34v1P0yiDHz144owVMfov
         rpCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVL7HWsWLEbLMu4j6Pt3o3iqOZhsiIag6gwGO4J+yYgJV9Rmeuud8wbXopCg+9HIWJJagwVpsSvm4DqHwa0@vger.kernel.org
X-Gm-Message-State: AOJu0YwL2tjGdfleCHeE78PG89XnwuV/8gJFJD8qnRdPzO6AFVQI1l2T
	tTtNUy5gyWLbYmIhp5zMoS7mnatWdHr/3n1YDA7T+i0WzwVia4Ps6rfgmAILdPaS8DVfkqsgxcC
	sweWqg6O23gkTGGrsK29kVw+19RjPhhdlQMppokq7Rg==
X-Gm-Gg: AZuq6aL2Kj9AKQKtTxqRLHTpxeQEJGI5TIB0QVtMdb1O1/hhoYBQ7HK1RcGFfsm4Xpk
	C6zudeSHIN5H+FO/CscSkJ+l8IGZ2vc+pP1qQiaHp++NflZ4sHdtb9EDl1bWPTMx+3OBiOK83jc
	kLrtbqWbMup5BXTfHWbtufJ79oEJMfa8om8viiLnb2rVeDoDPGWki3QtpQzDUfnd4mkO7N+KVSl
	i/11fnoigLSeDfmmuwTrX7nzIPQ4c9YvdNSwrrEWmT5IPv1jHvTISWi5AgOc4yEjj+mD1eUM/ii
	xatabQD8ADy7eP3hYD219lus+WnoRsBgrrqoki8ATDVDZrGRKu2fgeLLCCfIZiczx8sh7ni5aYx
	AgsnGnPCQXtgRsEQ=
X-Received: by 2002:a05:6000:4284:b0:435:bcbe:d104 with SMTP id
 ffacd0b85a97d-43797913f31mr29698913f8f.34.1771426253517; Wed, 18 Feb 2026
 06:50:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-15-neelx@suse.com>
 <20260208152914.3379032-1-clm@meta.com>
In-Reply-To: <20260208152914.3379032-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Feb 2026 15:50:42 +0100
X-Gm-Features: AaiRm5279eD5QNXNIKOKA9PJgdBQDs7fON79j563pfmi1shHVB7og3gAxuO5tGo
Message-ID: <CAPjX3FcyGRN4PZSJCjj37TtK3cYjkBK8qiguPRZFDyQ1igH4cQ@mail.gmail.com>
Subject: Re: [PATCH v6 14/43] btrfs: handle nokey names
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1152-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 7D35B1572DF
X-Rspamd-Action: no action

On Sun, 8 Feb 2026 at 16:30, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > For encrypted or unencrypted names, we calculate the offset for the dir
> > item by hashing the name for the dir item. However, this doesn't work
> > for a long nokey name, where we do not have the complete ciphertext.
> > Instead, fscrypt stores the filesystem-provided hash in the nokey name,
> > and we can extract it from the fscrypt_name structure in such a case.
> >
> > Additionally, for nokey names, if we find the nokey name on disk we can
> > update the fscrypt_name with the disk name, so add that to searching for
> > diritems.
>
> Hi everyone,
>
> I'm running the btrfs for-next branch, along with the encryption patch set
> through my AI review prompts:
>
> https://github.com/masoncl/review-prompts
>
> I'm working on some btrfs specific instructions, but hopefully these reviews
> are already useful.  I've kept the headers to make it easier to double check
> that I'm actually replying to the right email, but please let me know if any
> parts of this are incorrect:
>
> commit fabad1c3ea82184fba8e78ce1da1b2fbe8c34fae
> Author: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>
> btrfs: handle nokey names
>
> This commit adds support for handling nokey names in btrfs, enabling
> proper hash calculation and disk name extraction for long encrypted
> filenames when the encryption key is unavailable.
>
> > diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> > index 6e10dd4a4e9e1..75c213bd826e9 100644
> > --- a/fs/btrfs/dir-item.c
> > +++ b/fs/btrfs/dir-item.c
> > @@ -228,6 +228,27 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
> >       return di;
> >  }
> >
> > +/*
> > + * If appropriate, populate the disk name for a fscrypt_name looked up without
> > + * a key.
> > + *
> > + * @path:    The path to the extent buffer in which the name was found.
> > + * @di:              The dir item corresponding.
> > + * @fname:   The fscrypt_name to perhaps populate.
> > + *
> > + * Returns: 0 if the name is already populated or the dir item doesn't exist
> > + * or the name was successfully populated, else an error code.
> > + */
> > +static int ensure_disk_name_from_dir_item(struct btrfs_path *path,
> > +                                       struct btrfs_dir_item *di,
> > +                                       struct fscrypt_name *name)
> > +{
> > +     if (name->disk_name.name || !di)
> > +             return 0;
> > +
> > +     return btrfs_fscrypt_get_disk_name(path->nodes[0], di, &name->disk_name);
> > +}
> > +
>
> [ ... ]
>
> > @@ -263,6 +287,8 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
> >
> >       if (ret == -ENOENT || (di && IS_ERR(di) && PTR_ERR(di) == -ENOENT))
> >               return NULL;
> > +     if (ret == 0)
> > +             ret = ensure_disk_name_from_dir_item(path, di, name);
> >       if (ret < 0)
> >               di = ERR_PTR(ret);
> >
>
> Does ensure_disk_name_from_dir_item() leak memory when it allocates a
> disk name? Looking at the call chain:
>
> btrfs_unlink_subvol() at inode.c:4583 calls btrfs_lookup_dir_item_fname(),
> which calls ensure_disk_name_from_dir_item(), which calls
> btrfs_fscrypt_get_disk_name() at fscrypt.c:34, allocating memory via
> kmalloc() and storing it in name->disk_name.name.
>
> However, btrfs_unlink_subvol() cleans up with fscrypt_free_filename() at
> include/linux/fscrypt.h:503, which only frees name->crypto_buf.name, not
> name->disk_name.name.
>
> The same issue appears in btrfs_search_dir_index_item() at line 405, which
> also calls ensure_disk_name_from_dir_item().
>
> For nokey encrypted filenames, wouldn't this leak memory on every
> successful lookup?

Should `name->crypto_buf.name` equal to `name->disk_name.name` in this case?
How about this:

--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -243,10 +243,18 @@ static int ensure_disk_name_from_dir_item(struct
btrfs_path *path,
                       struct btrfs_dir_item *di,
                       struct fscrypt_name *name)
 {
+    int ret;
+
     if (name->disk_name.name || !di)
         return 0;

-    return btrfs_fscrypt_get_disk_name(path->nodes[0], di, &name->disk_name);
+    ret = btrfs_fscrypt_get_disk_name(path->nodes[0], di, &name->disk_name);
+    if (ret)
+        return ret;
+
+    name->crypto_buf.name = name->disk_name.name;
+    name->crypto_buf.len  = name->disk_name.len;
+    return 0;
 }

 /*

Thanks.

--nX

