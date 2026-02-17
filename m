Return-Path: <linux-fscrypt+bounces-1137-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJLTGdx/lGmwFAIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1137-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Feb 2026 15:49:00 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE21514D496
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Feb 2026 15:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98FB03038AE2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Feb 2026 14:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02FC236C5A0;
	Tue, 17 Feb 2026 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cz3swEMt"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D148329395
	for <linux-fscrypt@vger.kernel.org>; Tue, 17 Feb 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771339714; cv=pass; b=FSfhBkRzvSi///V+cX74614PyZmZWFW+kNIUSVupDHogXL6Z0h4Sn6bpmYupkSMpnu4Bf/w8LYTqskAjlLBcgpCk0zh0xb1Ef/yVTR4HRfOYUJfUXaLJWXBAe0WhXCibpNt3UDLw7EMQQd+viiKQDP+5NAeYrVvu+Vwxw20gjXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771339714; c=relaxed/simple;
	bh=BdwdGKvnO7fFw0MoaFXmtoP5xcQ32uwyD+1ybxKNc1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YaxxiphA84lj22xC+5/26ir4KZwyyBNoBpmOouA1NwBBMWa8zdvYOpJUD0Uptlj6ekuvkUmJHj8YW4hvfx011FiCoAWlMZn9cc+PEFrFeixRCnjHHveuZZk+c4y0lJRiSaW/y2nM0ewOlP3phwpjcMn8melPF3SWW4Oe0jAr3HY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cz3swEMt; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4377174e1ebso3252123f8f.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Feb 2026 06:48:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771339712; cv=none;
        d=google.com; s=arc-20240605;
        b=J60PVMvZ+Uz1bYaQ1Oj7UnobOLy+K88XFvUipinypQz2u394fwAVhThREcjtkPnDZS
         DpCppSXUz6qLWDxzQ7AX+sH/cztagIOZdg/ZPPK9JzY4ANHzduPVmA5AlLFNwMQ0gypP
         oh7J00Hr/l18yQMql9U8rG4AEmloyoKB2L0B91o/XTy9uFJgO+Ws2feOoeda3tn2FtAx
         bm9C/F03ZEaAiNK3teVpkEXqppU71ZCX2cWaZWBesYh/j4WMuFwVGtuyWqxOxAD33Au6
         Nb45pRUstgM/0jxnV62uL+l7R1tk8+avGJTWDbicTc4HHQaNBb4vqhPF786n5L2ExBls
         2JOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eLr2cRWBw8S0/OXlKOzbRmg5bkPMrPDlaj10p1kdwTE=;
        fh=+LIDHzCqSDM50qOLyecSvh8N4aFFXqNJ8KZZwdjihx4=;
        b=dvJQSl6bp+aOeqUSPtR1jzebDGQ5uu01TBmD2+vSpqKsBjMrAINKdwFW4LcyiQfQXV
         /D9WtsyeyZZSeAstWGgzIsAnsgoZoUTK6VS9YGOKMjNYUvknRFkD6edP8tt2JHRh3nrJ
         VXX2ui71MswoX2oWzvPqgSKnb5Zs3myKl0fgM0NBuIEKPdUY0rYvtTc9pTd6WZetrg97
         fMroVYApphxjplA+KcKLHBccIGLy4Q5gyRzySj2/7+Ftji4GVSPVakyv1RMOhzWZfx+c
         J7BODUt589hhHSeZ5LcLC0jQnoobDMtm41AUfxOMPX4zctUQcajONHFfDX+hNUbF3nLm
         6bqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771339712; x=1771944512; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eLr2cRWBw8S0/OXlKOzbRmg5bkPMrPDlaj10p1kdwTE=;
        b=cz3swEMtk3PN2RvOTaW1z9hz0lQ4TdrxSP5U4gFFonwIFdUREVJHg2O0IHPFiUgqAI
         /uLteasIn9nknhnHTDUkGJRc/i5uKsLd3jaXqFXT6zVXHjGWz3C3yloiJNOqXQcqBBsV
         jCokeQ61LqCfTqKJ2wcPo/zgjmO2BiS6tkgRih/Gi0XRIYCABxADDHT98I2HVyvzU/A1
         djJbUeL74d4jMn70Bev0C9NAjMdbKk7xepPqG4QNTrbsgHaylLMgTa9tfmO37CODknEu
         +E1/4EBZQWP3owZXPGPNAZJoaJoGF/43yIGsyO5nvGgSTyu+nuWPqb8WztbMWQUYhWMi
         OoWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771339712; x=1771944512;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eLr2cRWBw8S0/OXlKOzbRmg5bkPMrPDlaj10p1kdwTE=;
        b=ojBrevJ6dUS3JPYvFiSmNkV7cJIXz9AaSjJBDvSYdNaAW8YCcK6KXx4bP+lnhB0ltL
         7tkCttt1ZKvaidveCPlX+cit+W/ffxeA9EYAD0tnP8j/GevVFOWcV0fjwgTy0uby+KjR
         fSa8VDBAKl408Btcuw1fuBhWfTDt2NA8Txlq5Q3HGCyQW6+hPgUklCdNSskbFAU0jUh9
         ylEOEV1mfL89Qi1aMqr2Nz6cflFX3q/svEholjwoWAmL7OsA75O60LANyDDWuTqfGw+g
         kz36u1duOyIJS8Zj/jP3pjtSpI1bTwo4x47hV+xv7+kXb7wFq4tLB9EGOBlsdoxEITH7
         IZEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu8tnAY1FQrfjl13scWqcB8FTaPOIzOgWn4Qy4X+FMsvcfzx4qm9SRlaafxtFU+Pxax2SocRafaKgW4lZO@vger.kernel.org
X-Gm-Message-State: AOJu0YwSr8MXnDYP1C7LFRZm93FlfjV0dhSR2VqAa3qu9b5llHr1XupH
	M/ywFPGvlOsKiGpvWAY43LuZykEjZVWmAw+OalavywP0irhLUPyVOZc+WUYve7mBIwYeog8RJzs
	+6zGNzK4BAyPSZml9/0x+tB20pOz0+aGJhHd3ByC7MA==
X-Gm-Gg: AZuq6aIol9f+tYKXog8X5qvQOqMmeS5pGIf2+z0p3rsWE/UGJVtXA/9GwBOa5MPlwbJ
	d9HDR+W59nO7YQUfEB7Rs69yp1lHgniV+9YSfpwK4RqJPl/o1PziIhxq5q1Xd4AaUVkO9DMN+5I
	EULWt+jFOj58Fe4mgE3QWG6FE28x0WJHJ09neRVAaxc0aFWs6l+07L6NhcToLHzsoI2zEwmIB3T
	XRsSkEiAbkAJyPSUZyn3xnVGdzuhqXvtHMKoySXYWPoJwymR2H3lIgStpzco9q26hlCgYYscCvL
	ppaRiksFrxSW8hz2mraD0+UjwbBy5Tsx8aq1XWQB4R4pSV3Xo2KV7SRgT/xkm8dGHt9Ar+1s2vl
	HdD90
X-Received: by 2002:a05:6000:1a8e:b0:435:8f88:7235 with SMTP id
 ffacd0b85a97d-4379790e98amr27190797f8f.33.1771339711651; Tue, 17 Feb 2026
 06:48:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-9-neelx@suse.com>
 <64126c50-063e-40e4-a536-233cce94b65e@infradead.org>
In-Reply-To: <64126c50-063e-40e4-a536-233cce94b65e@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 17 Feb 2026 15:48:20 +0100
X-Gm-Features: AaiRm51hHUsbfTUEHtSwC9qIQM4TJ160IJ28Zz9PQrmVkFY3H02cMBpf6HPloMc
Message-ID: <CAPjX3FfLFDS5Q32BzbhPgohsX250f8+JX_YbKPLVaGqVGcfV6g@mail.gmail.com>
Subject: Re: [PATCH v6 08/43] fscrypt: add documentation about extent encryption
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
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
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,infradead.org:email,toxicpanda.com:email];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1137-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: BE21514D496
X-Rspamd-Action: no action

On Fri, 6 Feb 2026 at 19:43, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 2/6/26 10:22 AM, Daniel Vacek wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Add a couple of sections to the fscrypt documentation about per-extent
> > encryption.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > v5: https://lore.kernel.org/linux-btrfs/7b2cc4dd423c3930e51b1ef5dd209164ff11c05a.1706116485.git.josef@toxicpanda.com/
> >  * No changes since.
> > ---
> >  Documentation/filesystems/fscrypt.rst | 41 +++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> > index 70af896822e1..8afec55dd913 100644
> > --- a/Documentation/filesystems/fscrypt.rst
> > +++ b/Documentation/filesystems/fscrypt.rst
> > @@ -283,6 +283,21 @@ alternative master keys or to support rotating master keys.  Instead,
> >  the master keys may be wrapped in userspace, e.g. as is done by the
> >  `fscrypt <https://github.com/google/fscrypt>`_ tool.
> >
> > +Per-extent encryption keys
> > +--------------------------
> > +
> > +For certain file systems, such as btrfs, it's desired to derive a
> > +per-extent encryption key.  This is to enable features such as snapshots
> > +and reflink, where you could have different inodes pointing at the same
> > +extent.  When a new extent is created fscrypt randomly generates a
> > +16-byte nonce and the file system stores it along side the extent.
>
>                                                alongside
>
> > +Then, it uses a KDF (as described in `Key derivation function`_) to
> > +derive the extent's key from the master key and nonce.
> > +
> > +Currently the inode's master key and encryption policy must match the
> > +extent, so you cannot share extents between inodes that were encrypted
> > +differently.
> > +
> >  DIRECT_KEY policies
> >  -------------------
> >
> > @@ -1488,6 +1503,27 @@ by the kernel and is used as KDF input or as a tweak to cause
> >  different files to be encrypted differently; see `Per-file encryption
> >  keys`_ and `DIRECT_KEY policies`_.
> >
> > +Extent encryption context
> > +-------------------------
> > +
> > +The extent encryption context mirrors the important parts of the above
> > +`Encryption context`_, with a few ommisions.  The struct is defined as
>
>                                      omissions
>
> > +follows::
> > +
> > +        struct fscrypt_extent_context {
> > +                u8 version;
> > +                u8 encryption_mode;
> > +                u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> > +                u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> > +        };
> > +
> > +Currently all fields much match the containing inode's encryption
> > +context, with the exception of the nonce.
> > +
> > +Additionally extent encryption is only supported with
> > +FSCRYPT_EXTENT_CONTEXT_V2 using the standard policy, all other policies
>
>                                                 policy; all other policies
>
> > +are disallowed.
> > +
> >  Data path changes
> >  -----------------
> >
> > @@ -1511,6 +1547,11 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
> >  buffers regardless of encryption.  Other filesystems, such as ext4 and
> >  F2FS, have to allocate bounce pages specially for encryption.
> >
> > +Inline encryption is not optional for extent encryption based file
> > +systems, the amount of objects required to be kept around is too much.
>
>    systems; the amount of

Thanks Randy. I'll amend all these in the next iteration.

--nX

> > +Inline encryption handles the object lifetime details which results in a
> > +cleaner implementation.
> > +
> >  Filename hashing and encoding
> >  -----------------------------
> >
>
> --
> ~Randy
>

