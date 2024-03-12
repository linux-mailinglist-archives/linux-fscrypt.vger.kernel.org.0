Return-Path: <linux-fscrypt+bounces-252-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 952E5879C96
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 21:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C3021F22A42
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 20:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8973142907;
	Tue, 12 Mar 2024 20:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ElgnVr/3"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C546D1428FC
	for <linux-fscrypt@vger.kernel.org>; Tue, 12 Mar 2024 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274075; cv=none; b=GFY5skeeig7fyMHUpCB1R/np07qKP2EXUjB7sCHqBGk10KtDfb514jgPHWi7PrWakbjiOGxb58n8r6HLuRUlP8lfvPjqySdwSRwA3YtfDAc/4y8ZR/vAtUTYUE5Xh/ERzfSUwsiSQjUOGuE1nZvZg6UFbnguYYWTLe+fV6qsbz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274075; c=relaxed/simple;
	bh=KK3vfTC21FfD3a3vNi4VaniP6dAy7ashn5OtgY1y6Kc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YzZ1pUW4XY5q8YeI7P7GvAMCXCs1/KrBVJt9eNv7K8oVV84Vh3MUbzji5ABkhSPPX8FBgOo/CPZ9SsH9oGgDYhbRFcHx1yby1StaRxM8wVaEcIiGf050Vfg6nS13uY4pHNJZUgxcCNSBHIYX+h5dFoMol7T8e1fDeZmeAAPXQM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ElgnVr/3; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dcc6fc978ddso215448276.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 12 Mar 2024 13:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1710274073; x=1710878873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIM56byQCwYfF5RCflaFTltitkLV02ChrYWIQLMiS/Y=;
        b=ElgnVr/3Q/zYk3p8cOr0srbGrwrn6SR+lC77XKGviNYk3F5Pp4ywOeBM4MexCiFGAb
         K1JldP5PIG50cuVSCEjquhwrRdW1pHztVk5hQWrrQlPiOtHgMfw+F8fjjPybyawQHeKp
         ZxyNdr8MI26Bj1AiSGBU6JkWMAFkvga9MPrGDq5CS+FiSwhZqZZb1peNgdyHRwBj1kM4
         l9k3SECxSnTxmpzXoVifZzVrBdkUrGT+ZITUIt2GnyCZmREQM6Z7LYy6M4h0oHBRApMC
         rXXmCc+zVuhcVCRcZsSBg/JWhX033y01J5x2vyxo0NS5vyCVyEcK20CHIOiuT6OGvjes
         4Prg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710274073; x=1710878873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIM56byQCwYfF5RCflaFTltitkLV02ChrYWIQLMiS/Y=;
        b=ERH76Ye6jC4Impc2+JwTbcydB93Zfde/zNs7Tvcy246dNmgqTGuVOBmVX/X9F866n1
         DXhgdEuNvH21gnD44tfI4tQa6u8Mn7L+xFl6ColTuQMQ266uCKH72Z2t8Wilzczcus6W
         KlJPOazOGqI/lvb+nac4iIMGMhxzMUGeVfQ46nszYcfg3VSCdPLQS1KEc0fGpvwu6lYK
         39wgdXgoUq6vJ52SiwlQQuPKuc6KV33x1Imq1dOVznUlEj7eYfSIaTzcbr5ix7Wzkzv8
         Edo+64YZWsthQvgmyNtMGrpEOlug11Uk34qIerpisxpsIbIBh3yXmtovQZNVT4W5QUrG
         SeYg==
X-Forwarded-Encrypted: i=1; AJvYcCXFUB9bEGMWFENKqL8ewMGCVMXVXlD9RxFqydrDlyOfe/O5X40kLansXltPn2PJfqQMY4Ct8IDMVE2KXke1GFyFC1a+gwCnldPlKjBuVg==
X-Gm-Message-State: AOJu0YwrXE/GDyApTP6enaHzjimsLtbZD+2mqVg6c0WB0RN6pe13w32m
	0pE6HRqp+a2DJAkGLmdIxzWFSSuYZgCz3AWGCX7CewCghzP6XefM8QjHy9C0VO+VT6oUC9Xx4Ik
	IXXJDQt5w0hKGcv8UzVuZSQLh004fJmEjzCzJ
X-Google-Smtp-Source: AGHT+IFUO9loFBNfYwY2rilDGi4a1ZxrFKhf7gDp1B59xt2uvInDy15QqH6xxud+73LelILqgfwJCkTcRwHNX1HB0r4=
X-Received: by 2002:a25:c714:0:b0:dcd:b806:7446 with SMTP id
 w20-20020a25c714000000b00dcdb8067446mr396824ybe.1.1710274072732; Tue, 12 Mar
 2024 13:07:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain> <20240312030712.GF1182@sol.localdomain>
 <51810153-eb6e-40f7-b5d0-5f72c2f4ee9b@linux.microsoft.com>
 <568fae5e-a6d4-4832-a1a1-ac3f4f93d650@schaufler-ca.com> <746a5548-0e98-4953-9e71-16b881c63aa8@linux.microsoft.com>
In-Reply-To: <746a5548-0e98-4953-9e71-16b881c63aa8@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 12 Mar 2024 16:07:41 -0400
Message-ID: <CAHC9VhTYoT-XrSp4h5QwT5tnzBS6NHG0XSQ=cKLueM0iM0DvJw@mail.gmail.com>
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM hook
To: Fan Wu <wufan@linux.microsoft.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Eric Biggers <ebiggers@kernel.org>, corbet@lwn.net, 
	zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, 
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 3:08=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> We could also make security_inode_setsecurity() more generic instead of
> for xattr only, any suggestions?

For the sake of simplicity, since security_inode_setsecurity() doesn't
work, it probably makes more sense to create a new LSM hook rather
than make significant changes to security_inode_setsecurity().

I'm looking at the fsverity hook usage in this patch as well as the
device-mapper hook usage in 13/19 with security_bdev_setsecurity() and
I'm wondering if we could adopt a similar hook as we do with block
devices:

/* NOTE: these are just example values, more granularity would likely
be needed */
enum {
  LSM_INTGR_DIGEST,
  LSM_INTGR_SIG,
} lsm_intgr_type;

/**
 * security_inode_integrity() - Set the inode's integrity data
 * @inode: the inode
 * @integrity_type: type of integrity, e.g. hash digest, signature, etc.
 * @value: the integrity value
 * @value: size of the integrity value
 *
 * Register a verified integrity measurement of an inode with the LSM.
 *
 * Return: Returns 0 on success, negative values on failure.
 */
int security_inode_integrity(struct inode *inode,
                             enum lsm_intgr_type type,
                             const void *value, size_t size)

... if the above makes sense, I'd probably adjust
security_bdev_setsecurity() both to have a similar name, e.g.
/inode/bdev/, as well as to take a lsm_intgr_type enum instead of the
character string ... unless we really need a character string for some
reason, in which case use a character string in both places.

--
paul-moore.com

