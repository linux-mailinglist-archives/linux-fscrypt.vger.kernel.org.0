Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2531A1115
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Apr 2020 18:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgDGQTF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Apr 2020 12:19:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36823 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgDGQTE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Apr 2020 12:19:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id n10so1029086pff.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Apr 2020 09:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=FAYOo35vrmg7MjcB8wgsI15H0mWBlr8a02TgCADcxlc=;
        b=L5FEauY4MkijTZ7fgoggXfNBCGvZ15FF+sTRYmNNk7yuAgV3gb0VVVuHKuZ2kBdEQT
         /cB8HUDhK1UlfEUujMfK8nRh/a2Xcg+PC95kHmI6b70CLkDftv5MXLlNFHodg5TTt3Kh
         NZM4qmayj1nZCyiVKe0rfMSNpzdvWX7osaVyFo3Rc/z6jhvtcvkAsZcZpkLH/ZUXiXPr
         LWZnRC+pren2td4tpdUiUtexZbKJZxG4ngy9j0LgT3FYGwiu68mbWu2KqVhdRU4hCA9h
         h7UBzvLwYiQsiJn20cRsyaJawk0IgFOkqnf8faGjKbZBmLYiwNFsPui9ll72PQ7pF8Lg
         Babw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=FAYOo35vrmg7MjcB8wgsI15H0mWBlr8a02TgCADcxlc=;
        b=Si67kdEc3VRRAqPZI3wseEcr9JnaWl3Pzh12GCHvV0p0HnhIMTRCMpyCH2JwZ6BRow
         Kc7nJKiHu56RZwYc5+M6rwGZCVHSt6gYOrfdeM1bwzeWonU1GZAA9866QN68NK0QZ0Nz
         GB3dz5k3WBYlBXbF2yZJkKlEfiK1lIdNPTQD6ghxVyiTpVy/c11CT4gDJdrVKVy+3KxM
         ozxtwIr3mfa5GPBtefc2UCmsConWfESmuVpLnrZ1+5CAuVrO4YvXhT1Trn2Z+v0drU4D
         +Ktd8kbug9Vu+nke9LcnPcmrIHtobVFRokqmoD+22SN/4dGIswLXJIajD1pgk6NrMnfV
         oCwA==
X-Gm-Message-State: AGi0PuYo1I2smF5BZdnuMILYZq5sTl6Z2ByNgBP29IlrduobHLEhNgv0
        H30k5YeBEaERkDZwgBRE25VtYxDHAnA=
X-Google-Smtp-Source: APiQypLp+R115Ecsj43bZoeEnthoFDpx52UouM9sjoPP0BnoJgJkRH33kY4LseTQ3nraiwrzOR4oKg==
X-Received: by 2002:a63:8e44:: with SMTP id k65mr2693540pge.452.1586276343154;
        Tue, 07 Apr 2020 09:19:03 -0700 (PDT)
Received: from [192.168.10.160] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id t4sm14404827pfb.156.2020.04.07.09.19.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Apr 2020 09:19:01 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <74B95427-9FB1-4DF8-BE75-CE099EA3A9A3@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A99B0851-BB44-499A-8776-EC29E2ABE2B8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Date:   Tue, 7 Apr 2020 10:18:55 -0600
In-Reply-To: <20200407053213.GC102437@sol.localdomain>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
To:     Eric Biggers <ebiggers@kernel.org>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
 <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
 <20200407053213.GC102437@sol.localdomain>
X-Mailer: Apple Mail (2.3273)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_A99B0851-BB44-499A-8776-EC29E2ABE2B8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Apr 6, 2020, at 11:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Wed, Apr 01, 2020 at 08:19:38PM -0600, Andreas Dilger wrote:
>> On Apr 1, 2020, at 2:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>>>=20
>>> From: Eric Biggers <ebiggers@google.com>
>>>=20
>>> The stable_inodes feature is intended to indicate that it's safe to =
use
>>> IV_INO_LBLK_64 encryption policies, where the encryption depends on =
the
>>> inode numbers and thus filesystem shrinking is not allowed.  However
>>> since inode numbers are not unique across filesystems, the =
encryption
>>> also depends on the filesystem UUID, and I missed that there is a
>>> supported way to change the filesystem UUID (tune2fs -U).
>>>=20
>>> So, make 'tune2fs -U' report an error if stable_inodes is set.
>>>=20
>>> We could add a separate stable_uuid feature flag, but it seems =
unlikely
>>> it would be useful enough on its own to warrant another flag.
>>=20
>> What about having tune2fs walk the inode table checking for any =
inodes that
>> have this flag, and only refusing to clear the flag if it finds any?  =
That
>> takes some time on very large filesystems, but since inode table =
reading is
>> linear it is reasonable on most filesystems.
>=20
> I assume you meant to make this comment on patch 2,
> "tune2fs: prevent stable_inodes feature from being cleared"?
>=20
> It's a good suggestion, but it also applies equally to the encrypt, =
verity,
> extents, and ea_inode features.  Currently tune2fs can't clear any of =
these,
> since any inode might be using them.
>=20
> Note that it would actually be slightly harder to implement your =
suggestion for
> stable_inodes than those four existing features, since clearing =
stable_inodes
> would require reading xattrs rather than just the inode flags.
>=20
> So if I have time, I can certainly look into allowing tune2fs to clear =
the
> encrypt, verity, extents, stable_inodes, and ea_inode features, by =
doing an
> inode table scan to verify that it's safe.  IMO it doesn't make sense =
to hold up
> this patch on it, though.  This patch just makes stable_inodes work =
like other
> ext4 features.

Sure, I'm OK with this patch, since it avoids accidental breakage.

One question though - for the data checksums it uses s_checksum_seed to =
generate
checksums, rather than directly using the UUID itself, so that it *is* =
possible
to change the filesystem UUID after metadata_csum is in use, without the =
need
to rewrite all of the checksums in the filesystem.  Could the same be =
done for
stable_inode?

Cheers, Andreas






--Apple-Mail=_A99B0851-BB44-499A-8776-EC29E2ABE2B8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl6Mp+8ACgkQcqXauRfM
H+AfPQ/+MNtXz4Btp84WD6OuAgKJqMUOHuMRInDto30kmS43CIPNehAVe+wfR+CK
F5McbDMueXNjNTefY81ny5CrPUgfYq3xu5GblVf0Udu+mvJHPCfcO7TErOTXEu48
t+1m+nNq2zyYOM8xVDqr47+3QNYQRUvagcJ08fwRYfwmU51dFmIe7HK1s5+VxCKF
3UWagZibUbrS4mfLEHHplJR1226hIKWa6RLeecVRlqE8t3Bg9pR98xuf0SbYoYQs
4yzTFAsX+AOF/1vwuHNfsY5TSN0jcQJAHeXfXtDMKXbeNlZeK5u0MHBsrcy9a5VZ
oeIuFAMldnFRSz9CQnxfsAQc/Knj/g+fRP36rtHMKQuyP4QbDbQl7FPH+eSDPTWq
SbHAgCaGd6k1irbkVpE/Lq+TpVZLvue4Pd3EKW4K/TbWpCy8W+si2Zja6/lx5c40
+4FzWe8LID35PPc576EYn4yIZXHi71ihYG6BDz6LIQlMQw+3U6v3dwgpUDSl+ZX6
B3oq80khCRFuqC7DLRKpy4VAMxanH03ZfPXMyPFF/E2Fy58Km9LLHZReoPpqi9Lr
8mLC5IDXQSXIVw3WOurz1XF9v0k2xKADuNVWC0CTwg28ZF6gD7ieEkwLrNA3W9kP
x0ga4MgyA8gQWHi7vgRJwMYPBXjOX+X7Z6mS3Tx2bdeKXSI4Xuo=
=H6Xg
-----END PGP SIGNATURE-----

--Apple-Mail=_A99B0851-BB44-499A-8776-EC29E2ABE2B8--
