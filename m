Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B5351D6C4
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 May 2022 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346061AbiEFLjm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 May 2022 07:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391400AbiEFLip (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 May 2022 07:38:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F5C60C9;
        Fri,  6 May 2022 04:35:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246B75QC019894;
        Fri, 6 May 2022 11:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=8RspyK0PRVi0UwT8ZnmwyEdIxA4z/RirluGKXyNrCTA=;
 b=pLybBU5TqODQcC568tj3fPG9m/p81DE+btfiHLCN7MVEElM8PTwhyZQvEH24NloC6iA3
 Q9PoYWEKMp7a5cvHxNOhkR3oroXaGBVe0hToM7vq8M86Ye6W65tdEoUA8+cYCq2/3vT6
 lc46T/6dY38fzASUhWbGiadTbFnXsdXcRSdwpbyFMS0zVWMQ1Do1p2S6Pic9RsRPuaBs
 MHf/aAKPYK7LHb56EPjPvVfwlXMokTGb4lh5hKYPixOcFns5LhL9HcBCFW6+FR1C7ymR
 VzX/dDXARzU1y6Vu6nZp0WrkabKBnA9De+VsnWP7SPTfV8g0B4UlBkqzWXapfU+IA4kG bw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw2av8pf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:34:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246BRfrU012987;
        Fri, 6 May 2022 11:34:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7fwdd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:34:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246BYsfb10223956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 11:34:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DEDC52050;
        Fri,  6 May 2022 11:34:54 +0000 (GMT)
Received: from sig-9-65-81-120.ibm.com (unknown [9.65.81.120])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7979F5204F;
        Fri,  6 May 2022 11:34:53 +0000 (GMT)
Message-ID: <e223929f4fbbfcba51b8cc9dda6a07ace12f5dd8.camel@linux.ibm.com>
Subject: Re: [PATCH v9 6/7] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 06 May 2022 07:34:52 -0400
In-Reply-To: <ae5889bc-f5aa-6d0a-fdce-81819a15d22c@linux.ibm.com>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
         <20220505123141.1599622-7-zohar@linux.ibm.com>
         <ae5889bc-f5aa-6d0a-fdce-81819a15d22c@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wZzEGnpUmiC3DEU-_QzHN1fbud1kxZT-
X-Proofpoint-ORIG-GUID: wZzEGnpUmiC3DEU-_QzHN1fbud1kxZT-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=758 adultscore=0
 mlxscore=0 clxscore=1015 spamscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 2022-05-05 at 13:12 -0400, Stefan Berger wrote:
> 
> On 5/5/22 08:31, Mimi Zohar wrote:
> > IMA may verify a file's integrity against a "good" value stored in the
> > 'security.ima' xattr or as an appended signature, based on policy.  When
> > the "good value" is stored in the xattr, the xattr may contain a file
> > hash or signature.  In either case, the "good" value is preceded by a
> > header.  The first byte of the xattr header indicates the type of data
> > - hash, signature - stored in the xattr.  To support storing fs-verity
> > signatures in the 'security.ima' xattr requires further differentiating
> > the fs-verity signature from the existing IMA signature.
> > 
> > In addition the signatures stored in 'security.ima' xattr, need to be
> > disambiguated.  Instead of directly signing the fs-verity digest, a new
> > signature format version 3 is defined as the hash of the ima_file_id
> > structure, which identifies the type of signature and the digest.
> > 
> > The IMA policy defines "which" files are to be measured, verified, and/or
> > audited.  For those files being verified, the policy rules indicate "how"
> > the file should be verified.  For example to require a file be signed,
> > the appraise policy rule must include the 'appraise_type' option.
> > 
> > 	appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
> >             where 'imasig' is the original or signature format v2 (default),
> >             where 'modsig' is an appended signature,
> >             where 'sigv3' is the signature format v3.
> > 
> > The policy rule must also indicate the type of digest, if not the IMA
> > default, by first specifying the digest type:
> > 
> > 	digest_type:= [verity]
> > 
> > The following policy rule requires fsverity signatures.  The rule may be
> > constrained, for example based on a fsuuid or LSM label.
> > 
> >        appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> 
> Acked-by: Stefan Berger <stefanb@linux.ibm.com>

Thanks, Stefan!

This patch set is now queued in the next-integrity-testing branch,
waiting additional review/tags. 

thanks,

Mimi

