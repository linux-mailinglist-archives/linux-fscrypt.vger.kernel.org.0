Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B4606A6C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 23:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJTVmD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 17:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiJTVmC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 17:42:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5FA1EA57C;
        Thu, 20 Oct 2022 14:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C44E61D33;
        Thu, 20 Oct 2022 21:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BEFC433D6;
        Thu, 20 Oct 2022 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666302120;
        bh=bXJ5Yqhnz5+l4b0IhPru/FH1tsaWDeiNfU37x/gOMu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abHaC9gyt2qt5QFrWe9uz8sfgPgtUmqXzjaT1kvYJHUEHZgzfgqa8D+MEOdQngcD0
         2e1J1yuYpY+GjcUzgUUuE8oZdim6gvqOtEDaseUd7LkgOyiWbZ/5xCkqjN+SVKuyPr
         0fYAh0+/75ZBp0Cs0DC3dlogzWXyx1k3i3TBhgYaQQcVJGaNhhddOjHDF/jkUqY4Tz
         Jsrmt4I1tBdrMzaINRql4xLn3rPJN9JwhhEX4/8QcKxMXevM0b29bul3vfN2z0h9Fb
         wF3iqFPh5l7CNwY5Il7RtTT5aaOlCqn0Jk8K8aGkMQqN/6eNj79pt09bR43lt/No/8
         8FTCcWMb4XbCA==
Date:   Thu, 20 Oct 2022 14:41:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 05/22] fscrypt: document btrfs' fscrypt quirks.
Message-ID: <Y1HApkGv06Bnjv+i@sol.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <6ffe9471b0caedf1e134d417644d2b3d1a273799.1666281277.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ffe9471b0caedf1e134d417644d2b3d1a273799.1666281277.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:24PM -0400, Sweet Tea Dorminy wrote:
> +For most filesystems, fscrypt does not support encrypting files
> +in-place.  Instead, it supports marking an empty directory as encrypted.
> +Then, after userspace provides the key, all regular files, directories,
> +and symbolic links created in that directory tree are transparently
>  encrypted.

As I mentioned on the previous version, I'd prefer if the support for encrypting
nonempty directories was at the end of the patchset.

- Eric
