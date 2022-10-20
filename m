Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5938B606A64
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 23:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJTVi0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 17:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiJTViY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 17:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DC8101E05;
        Thu, 20 Oct 2022 14:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6F27B82928;
        Thu, 20 Oct 2022 21:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B30C433C1;
        Thu, 20 Oct 2022 21:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666301901;
        bh=KxCU+VIf+JXpGyNXeISHJATdCENbDY1XmvJCTkCNAhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I5uz+dYkUt/hLLZzv+PDgnsB2g0bPLK6QHQIkeB0DlgJ8hDQ1uhuqHc+/o1VNyMO7
         bl5EoNM5xIq8wiLBINiL5McxKIontnkAVAkPAHoIwSYFwBoOQllUf8uWLOEScLJI2o
         flO/Z/rQJokam6AaYm6yNabxIxF3c9GrA4RExxuV/IX4igc/5TTXtKoIlb2xwlxrOx
         0fysIYK5WDG1yP7Ld28BrMfMAXMYz2VWLG0fQPEctogKxEyu65sCV6FxpAxAfRB4hH
         r5R0iYB8xZzKGKPTxDETAOZgccPnLkK/ErQ4FlEO9yGBOlRe1i27yZL0CmUy3oLgIi
         TrQ9GSyMhXygA==
Date:   Thu, 20 Oct 2022 14:38:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 00/22] btrfs: add fscrypt integration
Message-ID: <Y1G/y2h3/uX95Z8E@sol.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:19PM -0400, Sweet Tea Dorminy wrote:
> This is a changeset adding encryption to btrfs.

Please always say which git tree and commit your patchset applies too.  Or pass
--base to git format-patch.  I tried upstream and btrfs, and neither worked :-(

- Eric
