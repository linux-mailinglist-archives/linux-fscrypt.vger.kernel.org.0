Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222EB4F71B8
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Apr 2022 03:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiDGBwo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Apr 2022 21:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbiDGBwd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 6 Apr 2022 21:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD8211BCCB;
        Wed,  6 Apr 2022 18:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C4C612A4;
        Thu,  7 Apr 2022 01:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5192EC385A1;
        Thu,  7 Apr 2022 01:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649296233;
        bh=KSjX707K2yOpklDkFe3hYkXxzGvA4HUFSojJhfJktmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LczaHNawhUlBcEdA2qj2WOiTqNMSnF6wexj5GxRK3ihpz0b5wZeJ4KafwslEHdklG
         6SMttkBgf24aB8wFy/vebqS4CdciMEdK1oSVvj0pqOtf3lwV+ODWO/bpbXXN+imUdo
         gSL19uxENhwkUHemjctGkD0cerrIwl/V69y+ul2gML3TU1RShu01+6VwYfNy7ldTgk
         Eua59MwiC++C0+dNv6TPYayAQRm3LkywPHKBeeIfGABVaeFspIwMN3vvE6wN7jl5vO
         Kc3OqgBnUzEInl19i7I5sAgB8V54OBTZTytcUESC3CB0ZFOqEnP/bdERuK2wce2hkT
         mwe/Cv1I9NU4w==
Date:   Wed, 6 Apr 2022 18:50:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: "Operation not permitted" message with "-g encrypt" in xfstests
Message-ID: <Yk5DZ+LZXVOKSjnt@sol.localdomain>
References: <20220406180826.6wdjr3zwzedstbft@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406180826.6wdjr3zwzedstbft@riteshh-domain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Ritesh,

On Wed, Apr 06, 2022 at 11:38:26PM +0530, Ritesh Harjani wrote:
> Hello,
> 
> Needed some help on "encrypt" group tests in fstests.
> 
> so when I run "./check -g encrypt". All my tests (ext4) fails with
> "keyctl_session_to_parent: Operation not permitted" print.
> 
> for e.g.
> qemu-> sudo ./check -s ext4_4k tests/ext4/024
> SECTION       -- ext4_4k
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 qemu 5.17.0-rc5+ #25 SMP PREEMPT Tue Apr 5 14:10:07 CDT 2022
> MKFS_OPTIONS  -- -I 256 -O 64bit -F -b 4096 /dev/loop3
> MOUNT_OPTIONS -- -o data=ordered /dev/loop3 /mnt1/scratch
> 
> ext4/024 1s ... - output mismatch (see /home/qemu/src/tools/xfstests-dev/results//ext4_4k/ext4/024.out.bad)
>     --- tests/ext4/024.out      2022-03-30 21:07:38.117980201 +0000
>     +++ /home/qemu/src/tools/xfstests-dev/results//ext4_4k/ext4/024.out.bad     2022-04-06 17:49:25.653513710 +0000
>     @@ -1,2 +1,3 @@
>      QA output created by 024
>     +keyctl_session_to_parent: Operation not permitted
>      Didn't crash!
>     ...
>     (Run 'diff -u /home/qemu/src/tools/xfstests-dev/tests/ext4/024.out /home/qemu/src/tools/xfstests-dev/results//ext4_4k/ext4/024.out.bad'  to see the entire diff)
> Ran: ext4/024
> Failures: ext4/024
> Failed 1 of 1 tests
> 
> SECTION       -- ext4_4k
> =========================
> Ran: ext4/024
> Failures: ext4/024
> Failed 1 of 1 tests
> 
> 
> On further investigation what I notice is -
> 
> When I run below command in qemu "sudo keyctl new_session" (which I think is
> also done by _new_session_keyring()), it returns "Operation not permitted"
> 
> i.e.
> qemu-> sudo keyctl new_session
> keyctl_session_to_parent: Operation not permitted
> 
> Is this because there is already some existing session or something?
> So when I do "sudo keyctl show", I see below.
> 
> qemu-> sudo keyctl show
> Session Keyring
>  699777301 --alswrv   1000  1000  keyring: _ses
>   63328941 ---lswrv   1000 65534   \_ keyring: _uid.1000
> 
> Could you please help with what am I missing here?
> So for now I ran with the tests with below diff, which ignores this operation
> not permitted print message. With this all the tests passes.
> 
> diff --git a/common/encrypt b/common/encrypt
> index f90c4ef0..a0920664 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -203,7 +203,7 @@ TEST_KEY_IDENTIFIER="69b2f6edeee720cce0577937eb8a6751"
>  # the session keyring scoped to the lifetime of the test script.
>  _new_session_keyring()
>  {
> -       $KEYCTL_PROG new_session >>$seqres.full
> +       $KEYCTL_PROG new_session >>$seqres.full 2>&1
>  }
> 
>  # Generate a key descriptor (16 character hex string)
> 
> But is there anything else which I should check to confirm "-g encrypt" tests
> actually gets excercised?
> 
> Also, do you know why this "operation not permitted" error while running with sudo?
> Do I need to change anything at my end? Or does this needs fixing at fstests level?
> 
> I agree by spending more time in understanding the encryption stack and how it
> is interacting with different kernel subsystems, I should be able to figure this
> out. But I assumed, that this test should ideally run out of box, if not then there
> is something very basic I am missing. I needed this for testing some basic cleanup
> work which I am doing in ext4 related to CONFIG_FS_ENCRYPTION.
> And wanted to make sure I test those changes against "-g encrypt" in fstests.
> 
> Please feel free to point me to the doc which I can refer for more information
> about this.
> 

First, I'm sorry you're running into this.  The reliance of the original version
of fs encryption on the process-subscribed keyrings has been a disaster, and I
spent several years fixing it to use filesystem keyrings instead.  I'm not at
all surprised this is where you happen to be having a problem.  We have to keep
testing the old interface, though, so that is why xfstests is still using it.

The tests want to start with an empty set of keys at the beginning of each test,
have them be accessible during the whole test (including by subprocesses), and
ensure they get deleted afterwards.  The way they currently do this is by
creating a new session keyring.  A process can replace its own session keyring;
however, there is no bash built-in for this, so instead the tests use
'keyctl new_session' which replaces the parent process's session keyring.

What I think is happening is that you're running xfstests in an environment
where the session keyring belongs to a non-root user.  'keyctl new_session'
(specifically KEYCTL_SESSION_TO_PARENT which it uses) as root will fail in that
case, since it requires that the parent keyring's UID be the same.

I guess this can happen fairly easily if you run xfstests from a sudo session,
though it might depend on the Linux distro.  I must have never noticed this
because for xfstests I always use one of the xfstests-bld test appliances, or
another system where I log in as root directly.

If this theory is correct, it should work if you do:

	keyctl session - ./check -g encrypt

For making it work by default, it is a bit tricky.  We could make the test
scripts, or 'check' itself, re-execute themselves using 'keyctl session', though
that's a bit awkward.  We could just skip creating a new session keyring
entirely (which is what your workaround did), though that would cause xfstests
to blow away anything that happens to be in your session keyring, which would be
bad if it's actually being used for something unrelated to xfstests.

Or maybe we could make xfstests stop using the session keyring directly, and
instead create a keyring "xfstests" within the session keyring, and work with
that only.  We may still need 'keyctl new_session' in the case where there was
no session keyring yet, as some Linux systems never set up a session keyring.

Aren't Linux keyrings fun?  :-)

- Eric
