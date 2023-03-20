Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE8A6C10A7
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 12:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCTLVC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 07:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjCTLUk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 07:20:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597D5A24B;
        Mon, 20 Mar 2023 04:20:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w9so45274857edc.3;
        Mon, 20 Mar 2023 04:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679311221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8sVUk19mi0ENvLdXL4dc1wi5Y68vF33xYYUnM/Y+b4=;
        b=N36boUDV7HOoTgzqioSkm3MXbjJim3un5x5Tc4BDS8kRe5KapgmG1MzBV5/fqDHOrt
         gjkwhj9Kiwl0tAC092PoPiXbj65Zq9nMmopzLx2l37FweObx8iP3kF1447u/o5uAIr7M
         0tuHkoqwfJ6bkcrpG03/MWj5Z8oSLns7vB/8nrge2aBmOApfAtMcnA9sA+muvrbHi/pg
         lmyril4EWypXHCmtxI9qV8ViFrUFSfTiTpRxMj+viAkITnUHm5iC41mcflXOdQoFT+4F
         7mStUaalQYY6B9QnrC/NyrnuYIBbmzo+vL3slEAYVvWcM10jIHHw0Aj7G+Sh4Xs4iymw
         MXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679311221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8sVUk19mi0ENvLdXL4dc1wi5Y68vF33xYYUnM/Y+b4=;
        b=3ZYgolYdKqm26Zkabm69bLKvlajhUSaoAGJUvqYccgTE+i0O69dXDb7X38wSk50od0
         GBjvDoB3cH9xcY2buEd34dLLOI8If5wYNyLXa0fjDRpVvAfSkX7a4AjcF3DW+WTWVpjw
         Q8gILcXJg3S1+6tOow+yL8rm3DsQiw4sX2Y1f8tgOVn0WD4jUIvLmK0Nffrt1QZfg0Av
         rFPzbNZpKRDr5EMfPVEpRz38xqCeGjv0+2QIe7n/ugbanyTtZIbq1vJFVj1w/zwHeYGb
         7baCM3evQVtw4t7PtxIxxatnrLhD0/1qBElrS3VtFpoSo12ZMhfc3M0SKriWcLq9rbjY
         FYww==
X-Gm-Message-State: AO0yUKVg4a0AHCGNokRjLxJMsjfHx+CyPB7tkMVvSG8u5dtfuIKU1uWj
        MRHyDRWB+Duh2OsOBd/rv3GsMF067TmXcHJOHAw=
X-Google-Smtp-Source: AK7set+Dn0AjhRJZc+MJf6gW1KJa8DUjZI/Fdxn0cmVGoZtVMjB0+zAMJOTRvehR3gk8I4LRsO6hF1LdLh2+y2Yp78c=
X-Received: by 2002:a50:8756:0:b0:4be:f5a0:a80f with SMTP id
 22-20020a508756000000b004bef5a0a80fmr6107654edv.0.1679311221362; Mon, 20 Mar
 2023 04:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230316181413.26916-1-lhenriques@suse.de> <568da52f-18a6-5f96-cd51-5b07dedefb2d@redhat.com>
In-Reply-To: <568da52f-18a6-5f96-cd51-5b07dedefb2d@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 20 Mar 2023 12:20:09 +0100
Message-ID: <CAOi1vP9QsbSUq9JNRcpQpV3XWM2Eurhk+6AkDDNmks5PLTx3YQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] ceph: fscrypt: fix atomic open bug for encrypted directories
To:     Xiubo Li <xiubli@redhat.com>
Cc:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 20, 2023 at 2:07=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 17/03/2023 02:14, Lu=C3=ADs Henriques wrote:
> > Hi!
> >
> > I started seeing fstest generic/123 failing in ceph fscrypt, when runni=
ng it
> > with 'test_dummy_encryption'.  This test is quite simple:
> >
> > 1. Creates a directory with write permissions for root only
> > 2. Writes into a file in that directory
> > 3. Uses 'su' to try to modify that file as a different user, and
> >     gets -EPERM
> >
> > All the test steps succeed, but the test fails to cleanup: 'rm -rf <dir=
>'
> > will fail with -ENOTEMPTY.  'strace' shows that calling unlinkat() to r=
emove
> > the file got a -ENOENT and then -ENOTEMPTY for the directory.
> >
> > This is because 'su' does a drop_caches ('su (874): drop_caches: 2' in
> > dmesg), and ceph's atomic open will do:
> >
> >       if (IS_ENCRYPTED(dir)) {
> >               set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> >               if (!fscrypt_has_encryption_key(dir)) {
> >                       spin_lock(&dentry->d_lock);
> >                       dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> >                       spin_unlock(&dentry->d_lock);
> >               }
> >       }
> >
> > Although 'dir' has the encryption key available, fscrypt_has_encryption=
_key()
> > will return 'false' because fscrypt info isn't yet set after the cache
> > cleanup.
> >
> > The first patch will add a new helper for the atomic_open that will for=
ce
> > the fscrypt info to be loaded into an inode that has been evicted recen=
tly
> > but for which the key is still available.
> >
> > The second patch switches ceph atomic_open to use the new fscrypt helpe=
r.
> >
> > Cheers,
> > --
> > Lu=C3=ADs
> >
> > Changes since v2:
> > - Make helper more generic and to be used both in lookup and atomic ope=
n
> >    operations
> > - Modify ceph_lookup (patch 0002) and ceph_atomic_open (patch 0003) to =
use
> >    the new helper
> >
> > Changes since v1:
> > - Dropped IS_ENCRYPTED() from helper function because kerneldoc says
> >    already that it applies to encrypted directories and, most important=
ly,
> >    because it would introduce a different behaviour for
> >    CONFIG_FS_ENCRYPTION and !CONFIG_FS_ENCRYPTION.
> > - Rephrased helper kerneldoc
> >
> > Changes since initial RFC (after Eric's review):
> > - Added kerneldoc comments to the new fscrypt helper
> > - Dropped '__' from helper name (now fscrypt_prepare_atomic_open())
> > - Added IS_ENCRYPTED() check in helper
> > - DCACHE_NOKEY_NAME is not set if fscrypt_get_encryption_info() returns=
 an
> >    error
> > - Fixed helper for !CONFIG_FS_ENCRYPTION (now defined 'static inline')
>
> This series looks good to me.
>
> And I have run the test locally and worked well.
>
>
> > Lu=C3=ADs Henriques (3):
> >    fscrypt: new helper function - fscrypt_prepare_lookup_partial()
>
> Eric,
>
> If possible I we can pick this together to ceph repo and need your ack
> about this. Or you can pick it to the crypto repo then please feel free
> to add:
>
> Tested-by: Xiubo Li <xiubli@redhat.com> and Reviewed-by: Xiubo Li
> <xiubli@redhat.com>

I would prefer the fscrypt helper to go through the fscrypt tree.

Thanks,

                Ilya
