Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEDA5AF8CC
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 02:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiIGAB6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Sep 2022 20:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIGAB4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Sep 2022 20:01:56 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7F28287A;
        Tue,  6 Sep 2022 17:01:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 72C6E80F7C;
        Tue,  6 Sep 2022 20:01:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662508912; bh=Sb9UkhtsrXPuDxUa35T7UO2P/mD0pL8/yRppn7zygm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cWoqOfvoa46sNKoZkIYgoYG9H4Om2sGiF53ZYLYxMjhaIpTk9p8NTFpwqU46WpIWW
         71BgpjDYPx+Gs0mkUUdb6/MX0cjrM2x494YOmdNlpdy096hScgDkRiKMXA6JB+28yr
         Ms7g414C4f6rt81Qa1RW6Nu5XOSYGj7QQ9LZV3WUW8aJXXkGl5nGAIlFHMqjgwjafj
         ofv/j3+RVjhKd9m7n1C6MvmHWFN6pKjMhjSwNw5NYnsrLIQmw6Bz5d7mdbePLaaz+x
         TFdMWML2KJwNjq/h0tBJF4k5J4N4qlixONbVvK/DMRy+4QMG5Vstu8YPH/s7R/zY9T
         y9eDS8+Dsbjug==
MIME-Version: 1.0
Date:   Tue, 06 Sep 2022 20:01:52 -0400
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/20] btrfs: add fscrypt integration
In-Reply-To: <YxfTYSWgGJsKf4fX@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <YxfLQzL9BYnxwaXQ@quark> <d1718c87-cec0-1796-8585-e89f28a8d3bd@dorminy.me>
 <YxfTYSWgGJsKf4fX@quark>
Message-ID: <e8a1a9c4f288f707025fef07537414e1@dorminy.me>
X-Sender: sweettea-kernel@dorminy.me
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 2022-09-06 19:10, Eric Biggers wrote:
> On Tue, Sep 06, 2022 at 07:01:15PM -0400, Sweet Tea Dorminy wrote:
>> 
>> 
>> On 9/6/22 18:35, Eric Biggers wrote:
>> > On Mon, Sep 05, 2022 at 08:35:15PM -0400, Sweet Tea Dorminy wrote:
>> > > This is a changeset adding encryption to btrfs.
>> >
>> > What git tree and commit does this apply to?
>> 
>> https://github.com/kdave/btrfs-devel/; branch misc-next. Should apply
>> cleanly to its current tip, 76ccdc004e12312ea056811d530043ff11d050c6 .
> 
> Patch 8 wasn't received by linux-fscrypt for some reason, any idea why?
> 
> $ b4 am cover.1662420176.git.sweettea-kernel@dorminy.me
> Looking up
> https://lore.kernel.org/linux-fscrypt/cover.1662420176.git.sweettea-kernel%40dorminy.me
> Grabbing thread from
> lore.kernel.org/linux-fscrypt/cover.1662420176.git.sweettea-kernel%40dorminy.me/t.mbox.gz
> Analyzing 22 messages in the thread
> Checking attestation on all messages, may take a moment...
> ---
>   [PATCH v2 1/20] fscrypt: expose fscrypt_nokey_name
>   [PATCH v2 2/20] fscrypt: add flag allowing partially-encrypted 
> directories
>   [PATCH v2 3/20] fscrypt: add fscrypt_have_same_policy() to check
> inode compatibility
>   [PATCH v2 4/20] fscrypt: allow fscrypt_generate_iv() to distinguish 
> filenames
>   [PATCH v2 5/20] fscrypt: add extent-based encryption
>   [PATCH v2 6/20] fscrypt: document btrfs' fscrypt quirks.
>   [PATCH v2 7/20] btrfs: store directory's encryption state
>   ERROR: missing [8/20]!
>   [PATCH v2 9/20] btrfs: setup fscrypt_names from dentrys using helper
>   [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
>   [PATCH v2 11/20] btrfs: disable various operations on encrypted 
> inodes
>   [PATCH v2 12/20] btrfs: start using fscrypt hooks.
>   [PATCH v2 13/20] btrfs: add fscrypt_context items.
>   [PATCH v2 14/20] btrfs: translate btrfs encryption flags and
> encrypted inode flag.
>   [PATCH v2 15/20] btrfs: store a fscrypt extent context per normal 
> file extent
>   [PATCH v2 16/20] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature 
> flag.
>   [PATCH v2 17/20] btrfs: reuse encrypted filename hash when possible.
>   [PATCH v2 18/20] btrfs: adapt directory read and lookup to
> potentially encrypted filenames
>   [PATCH v2 19/20] btrfs: encrypt normal file extent data if 
> appropriate
>   [PATCH v2 20/20] btrfs: implement fscrypt ioctls

Patch 8 is large and dull, and bounced from linux-fscrypt@ for size, but 
b4 gets it for me. b4 -p linux-fscrypt recreates the missing [8/20]; is 
it possible that option is set somewhere in your configuration?

$ b4 am -o- cover.1662420176.git.sweettea-kernel@dorminy.me | git am
Looking up 
https://lore.kernel.org/r/cover.1662420176.git.sweettea-kernel%40dorminy.me
Grabbing thread from 
lore.kernel.org/all/cover.1662420176.git.sweettea-kernel%40dorminy.me/t.mbox.gz
Analyzing 23 messages in the thread
Checking attestation on all messages, may take a moment...
---
   ✓ [PATCH v2 1/20] fscrypt: expose fscrypt_nokey_name
   ✓ [PATCH v2 2/20] fscrypt: add flag allowing partially-encrypted 
directories
   ✓ [PATCH v2 3/20] fscrypt: add fscrypt_have_same_policy() to check 
inode compatibility
   ✓ [PATCH v2 4/20] fscrypt: allow fscrypt_generate_iv() to distinguish 
filenames
   ✓ [PATCH v2 5/20] fscrypt: add extent-based encryption
   ✓ [PATCH v2 6/20] fscrypt: document btrfs' fscrypt quirks.
   ✓ [PATCH v2 7/20] btrfs: store directory's encryption state
   ✓ [PATCH v2 8/20] btrfs: use fscrypt_names instead of name/len 
everywhere.
   ✓ [PATCH v2 9/20] btrfs: setup fscrypt_names from dentrys using helper
   ✓ [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
   ✓ [PATCH v2 11/20] btrfs: disable various operations on encrypted 
inodes
     + Reported-by: kernel test robot <lkp@intel.com> (✓ DKIM/intel.com)
   ✓ [PATCH v2 12/20] btrfs: start using fscrypt hooks.
   ✓ [PATCH v2 13/20] btrfs: add fscrypt_context items.
   ✓ [PATCH v2 14/20] btrfs: translate btrfs encryption flags and 
encrypted inode flag.
   ✓ [PATCH v2 15/20] btrfs: store a fscrypt extent context per normal 
file extent
   ✓ [PATCH v2 16/20] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature 
flag.
   ✓ [PATCH v2 17/20] btrfs: reuse encrypted filename hash when possible.
   ✓ [PATCH v2 18/20] btrfs: adapt directory read and lookup to 
potentially encrypted filenames
   ✓ [PATCH v2 19/20] btrfs: encrypt normal file extent data if 
appropriate
   ✓ [PATCH v2 20/20] btrfs: implement fscrypt ioctls
   ---
   ✓ Signed: DKIM/dorminy.me
---
Total patches: 20
---
  Link: 
https://lore.kernel.org/r/cover.1662420176.git.sweettea-kernel@dorminy.me
...
