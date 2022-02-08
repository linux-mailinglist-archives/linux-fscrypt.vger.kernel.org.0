Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD84ADBC8
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 15:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378960AbiBHO52 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Feb 2022 09:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378991AbiBHO51 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Feb 2022 09:57:27 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE08C06157A;
        Tue,  8 Feb 2022 06:57:26 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218EfT69029974;
        Tue, 8 Feb 2022 14:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YIELr6G77NKbsfwh+N0gl4RoNyBwUD/wqOTeC2MHvk8=;
 b=Pj11Ydg7PLoNTBbkwm7aEp/YqyrrD8SLXrFgtmJLN5KiSjUNmaA9OL+a2g9EC/siBfzO
 MCK1OqIgUwqBxhq0lgkP12EF6iN37BdZaMm3n2iRhjnTxlTkG+C6imMiIASAQ7iq7H2V
 4mzQWP5ZJdAgXdTRVVXK3OWT4VI1QL3cskGX+jmDjjRz0hBQg7M4SKAUydxeNlEtvRkw
 AcGx5mGyUl2Z1xwzVZs2YMRC6TN2JZnyPqLV+Y8M8MOkHYtlTvYnom/38+GhtzCf8fRQ
 4nji+4wTtQCnoVuzX1CiMeG0iTO/TIkAE3TRxbOs2SFNBfUhM1tEy3g3qEPa48+7uEDx PA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e231a2h54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:57:23 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218EqWTt028404;
        Tue, 8 Feb 2022 14:57:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gv9dme0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:57:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218ElE9u34472284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 14:47:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59582A405B;
        Tue,  8 Feb 2022 14:57:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76450A405C;
        Tue,  8 Feb 2022 14:57:18 +0000 (GMT)
Received: from sig-9-65-88-92.ibm.com (unknown [9.65.88.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 14:57:18 +0000 (GMT)
Message-ID: <329b719e7fe302a9fa13325687061634a8d99977.camel@linux.ibm.com>
Subject: Re: [PATCH v4 0/8] ima: support fs-verity digests and signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 08 Feb 2022 09:57:17 -0500
In-Reply-To: <YgIEsLsoe/sHsjBr@sol.localdomain>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
         <YgIEsLsoe/sHsjBr@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dNHKBCjZs7DhyG0jU034nOodRBFZCB1R
X-Proofpoint-GUID: dNHKBCjZs7DhyG0jU034nOodRBFZCB1R
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202080090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-02-07 at 21:50 -0800, Eric Biggers wrote:
> On Mon, Feb 07, 2022 at 08:41:32PM -0500, Mimi Zohar wrote:
> > Support for including fs-verity file digests and signatures in the IMA
> > measurement list as well as verifying the fs-verity file digest based
> > signatures, both based on IMA policy rules, was discussed prior to
> > fs-verity being upstreamed[1,2].
> > 
> > Support for including fs-verity file digests in the 'd-ng' template field
> > is based on a new policy rule option named 'digest_type=verity'.  A new
> > template field named 'd-type' as well as a new template named 'ima-ngv2'
> > are defined to differentiate between the regular IMA file hashes from the
> > fs-verity file digests (tree-hash based file hashes) stored in the 'd-ng'
> > template field.
> > 
> > Support for verifying fs-verity based file signatures stored in the
> > 'security.ima' xattr is similarly based on the policy rule option
> > 'digest_type=verity'.
> > 
> > To differentiate IMA from fs-verity file signatures a new xattr_type
> > named IMA_VERITY_DIGSIG is defined.  Signature version 3, which is a hash
> > of the ima_file_id struct, disambiguates the signatures stored as
> > 'security.ima' xattr.  fs-verity only supports the new signature format
> > (version 3).  To prevent abuse of the different signature formats, policy
> > rules must be limited to a specific signature version.
> > 
> > [1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
> > [2] Documentation/filesystems/fsverity.rst
> 
> What does this patchset apply to?  I'm no longer able to apply it.  I tried
> both v5.17-rc3, and the next-integrity branch of
> https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git.

Just refreshed 'next-integrity' now.

-- 
thanks,

Mimi

