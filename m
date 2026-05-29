Return-Path: <linux-fscrypt+bounces-1610-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cEg1HG2rGWpdyQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1610-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2026 17:06:21 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE336043C3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2026 17:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6A20C3127882
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2026 14:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F5B363C4C;
	Fri, 29 May 2026 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hq6mQPnl"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A0364EB0
	for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780066298; cv=pass; b=hvzhOVwOQILDjzCQIz4KTBoi7OO1XlN5ewo02QA9FVSmjyXlbFbTYt0bixVS6Ezg71rkXZfCjsdMABdZ0O6eB2Sl4/inePOQ/A24UqLkPK7AlL/acJFBzDjJj2wf8xNCG4ad8LCmMOzWp35sqPfiugfUXPNd5/ABTseKYlFFBI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780066298; c=relaxed/simple;
	bh=GHjSbL147+woEuEDHu1Sw2wgGVb8jF7lNaayhkWhvu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlLhOzk/9gPW8hfj3nKQauIIkcE6WsG0y0MGhXDr0HUUbcdVa5EYFwUem+HH+EQ0Gru59FmzvbOUtgtYGMGBX0kMtQmamreiXLy3RoIYphePPACJ5dfH3l+FZR9Vwo/ISX6RAqnLvg27zPa8NEKZ1DHFs8E3xQqEl4dK1Fp+zV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hq6mQPnl; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45eeea039ebso705239f8f.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2026 07:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780066293; cv=none;
        d=google.com; s=arc-20240605;
        b=AfFH3S40ItMZFz9wpfkYjfcM+O1+agnAsmvjwblfTiHkF/UtivL4D1wKMUslgnx5PW
         sdBAfu5bAV0DHwnMAEKDP7QhkFRsml3D8xObBCZtH+XATgeJxACxwOzcWEvQgcyIMkSG
         Y+RP3ppBab3YpUvm4XIlLVQPtUCMm2puw8WY1R/1jIkc1s0CBXVDxlKPJP7dBkj6HQMi
         7CN/zI7vlKDjtIHzeghfWVoyFr6ZAZsvN62TB5sRD1jBn9WZK/vyqbGlwn06LsrPtugO
         Z2W48KU3XrbuODXAWy+Azce8R+PHrtErFlnf8Ztqp55pLX2bK27MZDP+aVtfgnLVvwsX
         3cbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+0Vmq3Hp4b/auYqZr8FjphzD6qcX8xEFQj0zpLYQha0=;
        fh=DdEr5sZUmX5gc4Yv5xzhNc3HRJidjnvY9rx0J86IwqE=;
        b=j22FuUt+UFAETYwrsFpcxQmhjyBgeFnp5KtqLoPDyWGykgZeS25foCIc5ap/LoD8Lt
         zQUZ7atkizT/hLhYDoGi1vZF/xN6454mGJjN9SHkpQTIdEf5OMu71fUrNX86Lhd2QuH7
         sQtaGnnG7C88hVkgCkzGY/Ng0ZVnC9o0Oqm72Zpf3CDGvw/LnSDrVzDFpzV+Z/dLCiT+
         HOd+kDmKwOusVrYYg6coyxX2dB1NWoL9Ux8v9+A2V2dk9UUFFKcL6xguMeDJwrq56QcJ
         /C39Gw6vXdPEaz3S1d16rUTZyNR24PJSK/3l+u/mfBxIGm28CO4jFRnB/yUvOra8xaQ+
         /3Jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780066293; x=1780671093; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+0Vmq3Hp4b/auYqZr8FjphzD6qcX8xEFQj0zpLYQha0=;
        b=Hq6mQPnlSyc0ww1/EIIE+gJItltSyFDx2eBmY8rIhVP1wefUlmwTjNi9O+4EdZECi6
         njHCjdKD0tFE4AIXEPzqLAe6FwabtbX/9ae14SZcv4PxrCWXcxMMI6NgIZU3K6KiW3p2
         PqWOSk/157p6chHJLdXhN2mDGuuv/WiyBqgFUuQBt2k6/qVV5gTa8YXKautcR4G7Fhnz
         eadxjqq/+cG+9CJLMwrWkp7B5ANtOBU8mHAMQSqfp0koNXgE0JgVsouq2IAg2J3J0/3Y
         hyZmvwWRatZ2tRamSC+ERRMy5jst9vWOEgMsgPykj7FKTCwUk01zmk842WkyNc6eqIzh
         OXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066293; x=1780671093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0Vmq3Hp4b/auYqZr8FjphzD6qcX8xEFQj0zpLYQha0=;
        b=kQSlPtofR7WmHzMb8JHcY/WR4febT0WhcRw81MwuB/FXzKBUkoDy927T9bFMO5kWL0
         0npv+7OjGv+WU0czGAUZuvnRdkyEvy7l+4ktxpf1mMrESjD4+JI/EqkPrBJKbyVhzO3g
         aHJfBsx3ClC/v0BwentiUdyXPUqWyq4lhKfKdnx2XUkX+dYR5M+SnPWR5wE2TnZ7jdUI
         IGPgSO+7Mkizu3Hk41dCkY18Cj3qw3quRLGDgNVkHXUwsuEtFkGsLdA70tcMSXWHLy+m
         xBS5aynHJPGh5iFflhQOES0HL8Jt9zQ5Us7vDlqJHW5Xf83RfmbXLCjYLUMvNFN6dIwH
         LKKg==
X-Forwarded-Encrypted: i=1; AFNElJ+ZFoHuciVISVLwvIDoMQ6TlSpHTnpAYSJU0e8BBwgm4LhFJSalbXAHPzmO3BBa2ALbBT0bvp5bNh31eiQM@vger.kernel.org
X-Gm-Message-State: AOJu0YzNtYoqLAKIuVgBKQyMeitlcYlLmHXn4JxLpObiDlkJtdOUcOZL
	yv2lhEwm9xnYxEigZ/YqLqTcmrwniEGNEIFsDE922iu6BXy9BCCQ24snJrum5zWDBvmv21KywQT
	VutfDEqkbUBFWrmTetrIgawv/pNIFRqfkOPpEXX+qSA==
X-Gm-Gg: Acq92OEG125JLYmZAwr86Elo3FEvZFXdIV9a8fn3fm9JApXq3VhqlKlkVHUrgwZWsbe
	O1LZWdU6DpmyEnlhUtzIIPs0UmTzFuq8A4qPSCrITrultlM8Ai4NwXTz9Wqvl8ZochGYTpO3Pkp
	g1Fw+2Ssaa1vG077HQTlP52oXg2wxL/UyRVbG5/Mr+WXtW0G9o+XX3gH1ONu30piRoJFoIhSrBS
	5mKQmCNhtDQgCIXious3pO6jd+NA8P4PXaCUBMvheyD5fbv4bCWoEjp0b869wP+AA9e+J/MevEt
	LU/tRJvxL/M+RJHFki9DSY82hJNwNnwazQZSk8WQQKdhXnftx6Jjo9/7ca5KVjiTZ15DDd7Jj2d
	up0cgkams/Rmp/EY=
X-Received: by 2002:a05:6000:160a:b0:43c:fc5c:a9fe with SMTP id
 ffacd0b85a97d-45ef6b6d56bmr140170f8f.20.1780066293416; Fri, 29 May 2026
 07:51:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-18-neelx@suse.com>
 <ahAfvPa_yl6AKZoW@infradead.org> <CAPjX3FeoGzNOBnmY5ie34irNaAOZiFqV_Ccf7dXFrZJeUXh8PA@mail.gmail.com>
 <ahBJdSKMly8rv04F@infradead.org>
In-Reply-To: <ahBJdSKMly8rv04F@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 29 May 2026 16:51:22 +0200
X-Gm-Features: AVHnY4L6Sj4CIQpoE8qqeTQsjviSoplxU_u3u53SGv7fIGYWGuBerFgqAZXaq_Y
Message-ID: <CAPjX3FddgRbmVOKPBTtyU16NqYg5OSzp3jAuVmetmu2uH14eRA@mail.gmail.com>
Subject: Re: [PATCH v7 17/43] btrfs: add get_devices hook for fscrypt
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1610-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid,infradead.org:email,suse.com:dkim]
X-Rspamd-Queue-Id: 0FE336043C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 22 May 2026 at 14:17, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 22, 2026 at 02:00:28PM +0200, Daniel Vacek wrote:
> > > How does this handled adding/removing devices at runtime?
> >
> > When called, this callback returns the list of bdevs opened by the
> > given superblock. If devices are added or removed, this function
> > returns a different list.
> > In other words it always returns a valid list.
> >
> > This is called from `fscrypt_get_devices()`, which is called from
> > `fscrypt_select_encryption_impl()` or
> > `fscrypt_prepare_inline_crypt_key()` or
> > `fscrypt_destroy_inline_crypt_key()`. All these functions walk the
> > returned list and discard it immediately afterwards.
> >
> > Note that with btrfs at this point we're only using the inline crypto fallback.
> > Is there any particular reason you asked this question?
>
> Well, assume you have a single device fs, and then you add a device
> later, you will not get the blk_crypto_config_supported call for this
> device, and it will not be taken into account.

This function is called from `fscrypt_prepare_new_inode()` from
`btrfs_new_inode_prepare()` as well as from many other places.
It looks quite OK to me and I can also confirm this with tracing.
Using the following bpftrace script:

```
fr:fscrypt_get_devices {
//      $num_devs = args.num_devs[0];
        $num_devs = ((uint32 *)args.num_devs)[0];
//      if ($num_devs < 2) { return; }
        printf("%s()\t\t\t(%4d %13s[%d])\tnum_devs %d\n", func,
                cpu, curtask->comm, curtask->pid, $num_devs);
}

f:blk_crypto_config_supported {
        printf("%s()\t\t(%4d %13s[%d])\tbdev %18p\n", func,
                cpu, curtask->comm, curtask->pid, args.bdev);
}
```

... and mounting an encrypted FS, then adding an additional device, like this:

```
$ mount /dev/vdb /mnt/scratch; \
echo -ne $TEST_RAW_KEY | xfs_io -c add_enckey /mnt/scratch; \
touch /mnt/scratch/dir/foo; \
btrfs device add /dev/vdc /mnt/scratch; \
touch /mnt/scratch/dir/bar
```

I'm getting this:

```
fscrypt_get_devices()            (   5         touch[26840])    num_devs 1
blk_crypto_config_supported()    (   5         touch[26840])    bdev
0xffff88a9c33fc880
fscrypt_get_devices()            (   5         touch[26840])    num_devs 1
fscrypt_get_devices()            (   5         touch[26844])    num_devs 2
blk_crypto_config_supported()    (   5         touch[26844])    bdev
0xffff88a9c3262b80
blk_crypto_config_supported()    (   5         touch[26844])    bdev
0xffff88a9c33fc880
fscrypt_get_devices()            (   5         touch[26844])    num_devs 2
```

Here you can see the newly added device is being considered.

Moreover btrfs only supports the fallback encryption due to the need
to compute the checksums of encrypted data stored on the device.

> Now can btrfs even support hardware inline encryption?  The way the bio
> processing is special cased I somehow doubt it.  But the concept of a
> static device list just doesn't work for btrfs, so I think the fscrypt
> side of this will need refactoring not to rely on it.  If we never
> support hardware inline encryption on such dynamic file systems that
> would be relative easy, if we need to support that case things might
> get a lot more complicated.

Yeah, this depends. If the device or fscrypt could return the checksum
to the FS, btrfs could use the inline HW encryption. Note that the
checksum must also be one that btrfs supports.
Otherwise we need to get the encrypted data to compute the checksum
ourselves. That is precisely why only fallback encryption is currently
supported. And it's where the FS callback hook is used to compute the
checksum.

--nX

