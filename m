Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DB52857BE
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Oct 2020 06:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgJGE10 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 00:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgJGE10 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 00:27:26 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AB3C061755;
        Tue,  6 Oct 2020 21:27:26 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d24so714451lfa.8;
        Tue, 06 Oct 2020 21:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sUSZKx+gAK2d8TpziPDTnI010bDZH5RIn0lG0CrorxI=;
        b=EhToGAaEsGAqO68+MxGfBW8HsmilYDiQnH5ejOkdoO8NVh2+yc/e6/7tOvK5uKE+mQ
         p30LDK2A2b8CXeCbGyLeBHGKADkuftlCwmR024aQHG81Uw6a0dWfA3mJyVSxnGfiLHS2
         zjCgpzm9BQHmxPtTB0IaaixtQgKdx7j7Ju75AnonGE/E75JyD34+PoQPrBFa0cw676eI
         1NcbK3BI2VB3Y3OKb/02Ym+diAk9Q05l0BHUTaGOScoN+Zy/pDUH0CAPgdhlEfBpZ8LY
         DQt92H++HWhYBcRWFFgx9itGkZb+jX5Ds4guywwixbPv4sLqx1ve+BPOAJNoeLnpoRTS
         m/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sUSZKx+gAK2d8TpziPDTnI010bDZH5RIn0lG0CrorxI=;
        b=TMjhFLZxnBH0eqUwxd8fs9olmAQD2DkiHm57obWOuSs4PWGkiD0+UJMN4JPq/uA4Fv
         vW5nAG9JqMscC6C8xEVfYcXhBmbYu4Kmsp+W0rwrHA67F9dhLZCmJWhnZGtIWA+sU516
         sxdgZZKmrj4pmmIk2ehykzzpegOkP36zu/ix20hSBE8CMKhLIJw1Yf53UYTejuWstIQo
         T1ZJRFhqm/qAMSC4WNYQkrLSZb7JTT4Lls+5MkHpuE5SGSgd8OAW2fbcltQ2VHBDw+xi
         xHULLmnxHe6XdoSdcG3AuqlqH8e88o8/g5r1yxcrkRPkvpasUatJU6Bzo7k1RCP0emdJ
         Bd4Q==
X-Gm-Message-State: AOAM530uLpbMec6HvpEBQw+neuAhmyBS46Lk32pTx3pS2iR/IRCAIgNg
        AFHLlqAfqLIJY59AL8ed80VDcKAAKTzIwml16Qk=
X-Google-Smtp-Source: ABdhPJyUDcHzDGEc1CwuNP8Hyo/bka2ZO6QsyZpz2VRXt7oWU2vzx59FQfJBikHOHgajYTY72TQ2Uw8SXUGTV8CsHk4=
X-Received: by 2002:a19:e042:: with SMTP id g2mr309118lfj.122.1602044844482;
 Tue, 06 Oct 2020 21:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201001002508.328866-1-ebiggers@kernel.org> <20201007034829.GA912@sol.localdomain>
In-Reply-To: <20201007034829.GA912@sol.localdomain>
From:   Daeho Jeong <daeho43@gmail.com>
Date:   Wed, 7 Oct 2020 13:27:13 +0900
Message-ID: <CACOAw_xO83YJjDoAK3O7aCK53pEihg=fTp-bMgkDsVM9_rMwEg@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH 0/5] xfstests: test f2fs compression+encryption
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Daeho Jeong <daehojeong@google.com>,
        linux-fscrypt@vger.kernel.org, fstests@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sorry for the late reply. We had a long holiday last week.
The patch looks good to me~

Thanks,

2020=EB=85=84 10=EC=9B=94 7=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 12:49, =
Eric Biggers <ebiggers@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Wed, Sep 30, 2020 at 05:25:02PM -0700, Eric Biggers wrote:
> > Add a test which verifies that encryption is done correctly when a file
> > on f2fs uses both compression and encryption at the same time.
> >
> > Patches 1-4 add prerequisites for the test, while patch 5 adds the
> > actual test.  Patch 2 also fixes a bug which could cause the existing
> > test generic/602 to fail in extremely rare cases.  See the commit
> > messages for details.
> >
> > The new test passes both with and without the inlinecrypt mount option.
> > It requires CONFIG_F2FS_FS_COMPRESSION=3Dy.
> >
> > I'd appreciate the f2fs developers taking a look.
> >
> > Note, there is a quirk where the IVs in compressed files are off by one
> > from the "natural" values.  It's still secure, though it made the test
> > slightly harder to write.  I'm not sure how intentional this quirk was.
> >
> > Eric Biggers (5):
> >   fscrypt-crypt-util: clean up parsing --block-size and --inode-number
> >   fscrypt-crypt-util: fix IV incrementing for --iv-ino-lblk-32
> >   fscrypt-crypt-util: add --block-number option
> >   common/f2fs: add _require_scratch_f2fs_compression()
> >   f2fs: verify ciphertext of compressed+encrypted file
>
> Jaegeuk, Chao, Daeho: any comments on this?
>
> - Eric
>
>
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
