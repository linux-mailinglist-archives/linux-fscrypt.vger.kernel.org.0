Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDAC63B34B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 21:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiK1UfA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 15:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiK1Ue7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 15:34:59 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A33F2B25D
        for <linux-fscrypt@vger.kernel.org>; Mon, 28 Nov 2022 12:34:58 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-14286d5ebc3so14523778fac.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 28 Nov 2022 12:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3kUD8/TTfav9EbeDIQ8ZZwVrosW/5Hgcdhi9BGeQU7g=;
        b=DN5OkkPDNLCxaFN2UuIezo27EMhAgaGg71EDTG24jCFvcjJ+UEWcw9yRaV6X+xTdEV
         /enMA14Sr9jDM4Q9owZOzFRmr4+fdIuC6gZN32yU6Fs56Omfv/xkQHlPL16vlkVyg1RM
         jJ7/i7hx/8PkDid/qAaFWqBNbJg2n0OAwL5TS/nRSZb/YGsXcrTfpYD6MPYYHqOp3GmQ
         g1rKlsNtb6AeHlDnEV2stYocc+V8tspFVKJpFZFuxy9lQpp6/3bsWnSPaMQO3Vcoindl
         u8unXiepGZRYgWTNwXh10W36lqXqP0RfWOq095Yz//bUa2+g9xsAdPTZRYUyA0x2mCmu
         HN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kUD8/TTfav9EbeDIQ8ZZwVrosW/5Hgcdhi9BGeQU7g=;
        b=GDGTTnXOP/nL6GXFpWWI67IRskiur4k6HoVW9cZF5iY7LoATLgc2iEPhFUMhVf20wY
         wRCC3OM/wx7rdxG2jCdGwyovuB4oIiimHCX2moLKtxVZdimJlXbOW2lTHVprbqa2Gvrr
         5WhRDJiduoakkD4RMMN+p7M1ve59d1wt61ygfSx3cn1pxdyt0HV1sM8z7O4pThPrN/7B
         4FNJluG7UMqehWhgIVSSE/68mZiN1+DoevHdJAvNVckV7hsWSAKwiAIDWQIVubJFheyp
         mCpylAhLmZJHAYR2y3fTS6f+KiiqgF0eBuCd02es+IJ1xxPh5kg6wKQQCMNurtOaLaaf
         6fFQ==
X-Gm-Message-State: ANoB5pnYII7GGaCxIrr+N4jEVhQVvq3Q8deuVhw85Mfu7bNdizKsomvK
        kOTZCr1IT7bc/qaa4mORqMZcO4qGGlT+W5N4kR6qdA==
X-Google-Smtp-Source: AA0mqf48wepdwdD988cC95590SQarOxOx/PbasQOurlJ3euIpsTj9iqEtW5r/l/Vj/yv5wdjBujhapZxq9RkOKG4VtA=
X-Received: by 2002:a05:6870:430a:b0:13d:5167:43e3 with SMTP id
 w10-20020a056870430a00b0013d516743e3mr20549124oah.257.1669667696999; Mon, 28
 Nov 2022 12:34:56 -0800 (PST)
MIME-Version: 1.0
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
 <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
 <81e3763c-2c02-2c9f-aece-32aa575abbca@dorminy.me> <55686ed2-b182-3478-37aa-237e306be6e1@dorminy.me>
 <4857f0df-dae0-178e-85e3-307197701d34@dorminy.me> <Y4RqbKSdxQ5owg0h@infradead.org>
In-Reply-To: <Y4RqbKSdxQ5owg0h@infradead.org>
From:   Paul Crowley <paulcrowley@google.com>
Date:   Mon, 28 Nov 2022 12:34:46 -0800
Message-ID: <CA+_SqcCFepKXXJWhF=d4pcEpMZ5XFO6j9buc+aHKpX9sP2+_KA@mail.gmail.com>
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Eric Biggers <ebiggers@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The kind of inline encryption hardware we see on Android devices tends
to have these limitations:

- as you indicate, loading keys can incur latency, so if many keys are
in use at once it can slow things down
- it's limited to using AES-XTS
- on UFS devices, the IV (transmitted in the DUN) must be zero in the
64 high bits
- consecutive blocks in the same operation use consecutive IVs
- there's no easy way to gather a checksum or MAC over the on-disk
ciphertext short of re-reading after writing

Android works around this with IV_INO_LBLK_64 policies, but these only
work well on the relatively small storage devices we use on Android.
In particular the IV limitation is very serious:

- inode numbers must be four bytes
- they must never change (so ext4 filesystem resizing is disabled)
- files cannot be more than 2^32 blocks

Things are worse on eMMC devices.

Even without this IV limitation, the security proofs for most AES
modes of operation start to look shaky as you approach the "birthday
bound" of encrypting 2^68 bytes with the same key. If your attack
model always assumes a point-in-time attack then you only have to
worry if you use a single key to encrypt a multi-exabyte storage
device; btrfs is designed to scale to such devices and more. If your
attack model includes an attacker who repeatedly gets access to the
storage device across time, then writing multiple exabytes with the
same key can be a problem even if some of those are overwritten. This
leads us to prefer per-extent AES keys (derived from a root key) if
possible. It's a shame AES doesn't have a 256-bit blocksize.

The way btrfs works also gives us some opportunities to do things a
little better. In general disk encryption has to make sacrifices to
deal with the limitation that IVs must be reused and there's no room
for a MAC. But because btrfs writes in whole extents, with fresh
metadata and checksum on each write, it becomes possible to use a
fresh IV and MAC for every new write. This opens up the possibility of
using an AEAD mode like AES-GCM. This combination gives us the
strongest proofs of security even against very generous attack models.

Our recommendation: btrfs should first build the ideal thing first
since it will have reasonable performance for most users, then later
design alternatives that make a few compromises for performance where
there is demand.


On Sun, 27 Nov 2022 at 23:59, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Nov 23, 2022 at 08:22:30PM -0500, Sweet Tea Dorminy wrote:
> > The document has been updated to hopefully reflect the discussion we had;
> > further comments are always appreciated. https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
>
> How is this going to work with hardware encryption offload?  I think
> the number of keys for UFS and eMMC inline encryption, but Eric may
> correct me.
