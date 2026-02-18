Return-Path: <linux-fscrypt+bounces-1153-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AF7RIAPVlWnFVAIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1153-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:04:35 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D8015741B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 378573022949
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC308341044;
	Wed, 18 Feb 2026 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V+GnKqXK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF776340A70
	for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771426966; cv=pass; b=UOsRYZCr/kijXdMytv/vbxSw7WVUJ5z09+d1l2iR8YFKFXuRU53cEryYGOMreBRgGKNgRdXPg5XNma1LmfGHH9SMO77B2R+CwSuWF7zXsOqIdP3qWLTHiIbXaOttbfNNehMAYqlgb4AKq9c8riGiEXnpi+UGrrN26FdIbNhqD4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771426966; c=relaxed/simple;
	bh=udw/ZyTsHuwFOVBESJ/+qihOlfdgJM950rv/L+IknkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pEInZjUh4nlQj7bIw67NslD7nhUJSKOMbbo7Ba5yMwCixy+hjRSF9TPhmrQvpNegfFu4Haixl+I4eRiLgu/ClxPVr+fj+HLx4M5KhDEabyvZj6D5+wh1ZVJ4IjtC8kYHJe4BXPZmfaufJrk2RGCykkS0Dvld2Z4LJxAeS+xrLZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V+GnKqXK; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48370174e18so35079845e9.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 07:02:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771426961; cv=none;
        d=google.com; s=arc-20240605;
        b=LTq0EqMc7kxIsZgtw3pYhCIW5RR0/z/854X2qfPj4qVweL1gJ7GKCbBfG5F/C+YoC2
         rmMz24x5EJhV14kmyEkg90CUpfWml2mgzshBq00rWUlHiE73B6zNDfkgEk1LnCUtA6N8
         1DAwZ2fQ+ZbnYoi+U5bZRSMZSbcDIQp6fwuASUpg/r1HBsoEtqLBfV66dwYP1DO9FWkj
         pFvuPFyjQhZrdO3GSIjwSHl68gp1QI/2Ec9ZMRueMA/oFNqxMib2B6EFcGmZ1VbtSb19
         pWn0C/lfiSOLceFSxPX8+3cmXlmwgvuOIfmNaCGJCZYCFinrYXUfwpFuQ9DElxF0J+It
         v16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4f2knTNw8Y0yBkMXA6kc+4x2KQKgICuj4A91rn0T+Sg=;
        fh=SNBuK5ZZF6JWphQVWggPDLJ7bjBPJOKfyQw9BtlOVg4=;
        b=HccwKCNvn3fhQRlnfdKu1J8x+A6fc7Y9rXxP2TF5VqvSoGdDg/TgcrdsesAcNVxemT
         sGAC3UgwCyp6MbRbVXwSm84/Btuvyv/QExdQHIVpk+cn2Cpq9c9HZpnWvUYNDaiGsLyC
         FqQ8RQFKcDhJSuIC1YBjWLXgEXduEjZgeNBKdk5fNT9fkjrQTQ9kdA5rvpWJDBkiCnk7
         w1iZaMZGgLEKC+IRz2nlTtYBiHSurcEXtVrO1w7wLF73J9dH2L4dDplNrD6/ZYpG9fs2
         SD8khw0UbPxQRceqcfJwl3NXzlZdBhxb/vktCtXYDd8NkvAtm/rQMoNisxkaA700YB3g
         rCWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771426961; x=1772031761; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4f2knTNw8Y0yBkMXA6kc+4x2KQKgICuj4A91rn0T+Sg=;
        b=V+GnKqXK60xaSJp2fZlMcxdqrWZWlyuvIxe5b7z69Ycpo06PAVrcE3DCVe/4lZrO/h
         a+LO52LcjnX8RPeBK38FQIbRW2t5p4QgITq+b/seBVc/nm8DgOLLqche7ucqkW+eNFTx
         86b98NQeX+5wShMg78VxLBTt2Gb3pkePa66IxvmX9wLJtxCSESq+Z6XCorkI3JvF8p4h
         JDybHtZvBeRBUu5TOfSx6DYsqOBLm76/FxdI0/8LkqE4wQJ6UVd2/wkTRxhETewCN9DT
         rxOCv/fQG2yvP1X6FKrQGxkEixttaZJdnZ+xExYL17sx/PL1qn8HaPZwO669LT/7rci7
         v2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771426961; x=1772031761;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4f2knTNw8Y0yBkMXA6kc+4x2KQKgICuj4A91rn0T+Sg=;
        b=Ek3vfcGAx4Cfey/DYUIhWRjAgYGbj2irF91MlXLk1fJsDScsOMyd/Vuf4ni1uhopPC
         A/L6+il2Ep7VUw5siMQqNmzS6k8OLgLODeZd8dEjUO89Kc6Uw3EEHz8IZAlCwmOEQxAC
         ya5f77vKWN8zXBfbfQffPx0RvhwhAUDnPx4fB6nK7/5bUrq4AEko7QWGSQsE3255kuVk
         JSwtnM99cxM7FV5LqhG/CPZK+9jymD4Td0KntqMrGhBIM4dptiiFXFZqV9Xho8aVvWi0
         BGTda9XxXecaRN9WHyNNojGwAtgoIDaJEXv1fLd/83/P7Aq16xRroBtlQeT+y2x7wED9
         BvVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTaasiSMSCG1JF5YdMcUKnuyWIXwfNy33SlXjzTT0iiTgrHWb2wsomQzH0GSx5T2xXcT/Th0X3+dzifxeB@vger.kernel.org
X-Gm-Message-State: AOJu0YxDYZYI00pJpeQ64SvqATdznlPVGCyoCwcBeuBu0pVcu2sTit/H
	CveVBXjnYVFVdq6qpQxUlfZTKP8MN4m9mRJGTEt6ZihRVGePXO4Lsg4VdaDo6JUbMKtLrU4iaSO
	6q1wa9B7RZoRiqIxOqTgzlAkZkwDzKEUpOnd5bLKwHA==
X-Gm-Gg: AZuq6aL69ZHeRKgX+TqKQu8oPB8xQAuZtLs+czyEA4wXxDR3JMacdBDK1grUJcOZJ+z
	2p+7NiT54NI4gjKxBQVUaJFDZs+Xd8JzoTg1uigpdlEuJWWSwbxi6Y0DKtkO1qwOB1QvDn2lILv
	3JJhS+RYRBQo4rcd9Qsncqpfjo6QqtCS//2V7XljvO3PU4K+RyO8Qz9vD4LP+AEA74TC8ixZ7Xl
	ksc3qF+IQs4GUPEH6UAgio7PfbJHFuBk27kIKuAITBZWtMF13B0By/y2/A9HrfAyDhw+zavEuvz
	aRQjMR3Z8oY5lvmSf0zw3SDNMEwG+iEJsWlXszfyCfqHB7DY4JIpVYP+r3GFd95+D1S2/pj8bh3
	pEpkd
X-Received: by 2002:a05:600c:1c25:b0:483:54cc:cd97 with SMTP id
 5b1f17b1804b1-48379bfc340mr230018315e9.36.1771426961169; Wed, 18 Feb 2026
 07:02:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-17-neelx@suse.com>
 <20260208152448.3300594-1-clm@meta.com>
In-Reply-To: <20260208152448.3300594-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Feb 2026 16:02:29 +0100
X-Gm-Features: AaiRm50heuopm7EY7a7udAfEdRYxhS7H4B61tJOKCzqxGFffQrIvg06EGcnPVCY
Message-ID: <CAPjX3FegzEdCxfBq4mqW2mP_GDDuyS4NOQqgDThWdAHhr2tCOg@mail.gmail.com>
Subject: Re: [PATCH v6 16/43] btrfs: select encryption dependencies if FS_ENCRYPTION
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
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
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,toxicpanda.com:email,meta.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1153-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: E1D8015741B
X-Rspamd-Action: no action

On Sun, 8 Feb 2026 at 16:25, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We need this to make sure the appropriate encryption algorithms are
> > turned on in our config if we have FS_ENCRYPTION enabled, and
> > additionally we only support inline encryption with the fallback block
> > crypto, so we need to make sure we pull in those dependencies.
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
> commit 0ab45d92f6f53371d87e1a302f09b56218d02546
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: select encryption dependencies if FS_ENCRYPTION
>
> This commit adds select statements for encryption-related dependencies when
> FS_ENCRYPTION is enabled, including encryption algorithms, inline crypto, and
> the block layer inline encryption fallback.
>
> > diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> > index ede184b6eda16..216a5707b099c 100644
> > --- a/fs/btrfs/Kconfig
> > +++ b/fs/btrfs/Kconfig
> > @@ -16,6 +16,9 @@ config BTRFS_FS
> >       select RAID6_PQ
> >       select XOR_BLOCKS
> >       select XXHASH
> > +     select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
> > +     select FS_ENCRYPTION_INLINE_CRYPT if FS_ENCRYPTION
> > +     select BLK_INLINE_ENCRYPTION_FALLBACK if FS_ENCRYPTION
>
> Are the dependencies for FS_ENCRYPTION_INLINE_CRYPT and
> BLK_INLINE_ENCRYPTION_FALLBACK satisfied?
>
> Looking at fs/crypto/Kconfig:38, FS_ENCRYPTION_INLINE_CRYPT depends on
> 'FS_ENCRYPTION && BLK_INLINE_ENCRYPTION'. Similarly, in block/Kconfig:204,
> BLK_INLINE_ENCRYPTION_FALLBACK depends on 'BLK_INLINE_ENCRYPTION'.
>
> When BTRFS_FS=y with FS_ENCRYPTION=y but BLK_INLINE_ENCRYPTION=n (which is
> valid), Kconfig will generate warnings:
>
>   WARNING: unmet direct dependencies detected for BLK_INLINE_ENCRYPTION_FALLBACK
>   WARNING: unmet direct dependencies detected for FS_ENCRYPTION_INLINE_CRYPT
>
> The build will fail when compiling fs/crypto/inline_crypt.c because
> BLK_INLINE_ENCRYPTION guards the required function definitions and struct
> members:
>
>   fs/crypto/inline_crypt.c:259:15: error: implicit declaration of function
>       'blk_crypto_derive_sw_secret'
>   fs/crypto/inline_crypt.c:317:9: error: implicit declaration of function
>       'bio_crypt_set_ctx'
>   fs/crypto/inline_crypt.c:418:45: error: 'struct bio' has no member named
>       'bi_crypt_context'
>
> Should BLK_INLINE_ENCRYPTION also be selected when FS_ENCRYPTION is enabled?

That's correct.

--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -18,6 +18,7 @@ config BTRFS_FS
     select XXHASH
     select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
     select FS_ENCRYPTION_INLINE_CRYPT if FS_ENCRYPTION
+    select BLK_INLINE_ENCRYPTION if FS_ENCRYPTION
     select BLK_INLINE_ENCRYPTION_FALLBACK if FS_ENCRYPTION
     depends on PAGE_SIZE_LESS_THAN_256KB


Thanks.

--nX

>   select BLK_INLINE_ENCRYPTION if FS_ENCRYPTION
>   select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>   select FS_ENCRYPTION_INLINE_CRYPT if FS_ENCRYPTION
>   select BLK_INLINE_ENCRYPTION_FALLBACK if FS_ENCRYPTION
>
> >       depends on PAGE_SIZE_LESS_THAN_256KB
> >
> >       help
>

